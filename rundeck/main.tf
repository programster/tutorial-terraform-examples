terraform {
    required_providers {
        rundeck = {
            source = "rundeck/rundeck"
            version = "0.4.7"
        }
    }
}


provider "rundeck" {
    url = var.rundeck_url

    # Specify the connection credentials. It is good to switch to using an auth token after initial deployment/config.
    auth_username = var.rundeck_auth_username
    auth_password = var.rundeck_auth_password
    #auth_token = var.rundeck_auth_token

    # Optionally specify the API verson of your rundeck server.
    #api_version = var.rundeck_api_version
}


# Add a private key to Rundeck for our project to use.
resource "rundeck_private_key" "private_key" {
    path         = "project/${var.project_slug_name}/my_private_key" # this path will be prefixed with "keys" when looking in rundeck in key storage.
    key_material = var.ssh_private_key
}


# Create a project for Rundeck.
resource "rundeck_project" "my_project" {
    name        = var.project_slug_name
    description = "An example project"

    # Specify the default SSH key that the project should use to connect to it's nodes on.
    ssh_authentication_type = "privateKey" # technically this line is not requires as is the default
    ssh_key_storage_path = "keys/${rundeck_private_key.private_key.path}"

    # https://docs.rundeck.com/docs/developer/03-model-source-plugins.html#about
    resource_model_source {
        type = "file"

        # Create the configuration for how the nodes in the project are defined. In this basic example
        # we just configure rundeck to create an editable YAML file in our docker volume for the project.
        config = {
            format = "resourceyaml"

            # This path is interpreted on the Rundeck server.
            file = "/home/rundeck/node-definitions/${var.project_slug_name}/nodes.yaml"

            # This allows Rundeck to edit the file through the UI.
            writeable = true

            # This tells Rundeck to create the file if it doesn't already exist, which it won't to start with.
            generateFileAutomatically = true
        }
    }

    # Specify the default SCP and SSH executors.
    # When I hadn't set these, I was getting authentication failures.
    default_node_file_copier_plugin = "sshj-scp"
    default_node_executor_plugin = "sshj-ssh"

    extra_config = {
        "project.label" = var.project_label
    }
}


# Create a job in Rundeck.
# https://registry.terraform.io/providers/rundeck/rundeck/latest/docs/resources/job
resource "rundeck_job" "my_job" {
    name         = "update-apt-servers"
    project_name = rundeck_project.my_project.name
    description  = "Update APT-based servers."

    log_level = "INFO"
    timeout = "30s"

    # Optionally schedule this to run every minute
    schedule_enabled = false
    time_zone = "Europe/London"
    #schedule = "0 0/1 * * * ?"

    # Specify if you wish for this job to be able to be executed. This gives you a quick way to disable a job.
    execution_enabled = true

    # Allow this multiple instances of this job to be run in parallel (e.g. two admins clicked run at the same time).
    # Don't get this confused with max_thread_count and command_ordering_strategy, which are to do with how many nodes a
    # single job can be executing across
    allow_concurrent_executions = true

    # Specify the maximum possible number of threads to execute this job with. 4 will mean that up to 4 nodes will be
    # executed against in parallel, depending on whether you even have 4 nodes that match your filtering, and also
    # taking into account your orchestrator settings
    # (see percent: https://registry.terraform.io/providers/rundeck/rundeck/latest/docs/resources/job#percent)
    # and count: https://registry.terraform.io/providers/rundeck/rundeck/latest/docs/resources/job#count
    max_thread_count = 4

    # Specify the strategy for how the job should execute across the nodes. E.g. do one at a time (node-first), or do
    # one step on each node before moving onto the next step across all nodes (step-first).
    # https://registry.terraform.io/providers/rundeck/rundeck/latest/docs/resources/job#command_ordering_strategy
    command_ordering_strategy = "parallel" # options are "parallel", "node-first", and "step-first"

    # Specify that we don't wish for a job to retry on error, but if it were, Rundeck would wait 30 seconds before trying
    # again.
    retry = 0
    retry_delay = "30s"

    # Specify whether the steps in the job for a single node should continue to execute or not, if an error is experienced
    continue_on_error = false

    # Specify whether rundeck should continue running on other nodes, if an error was experienced running the command(s)
    # one one of the nodes.
    continue_next_node_on_error = true

    # Specify whether the job should be considered success if no nodes matched your filtering.
    success_on_empty_node_filter = true

    # Optionally filter your nodes based on tags.
    node_filter_query = "tags: apt"

    # Run a command to output the percentage utilization on the root partition
    # Please refer to https://registry.terraform.io/providers/rundeck/rundeck/latest/docs/resources/job#shell_command
    command {
        inline_script = file("./example-bash-script.sh")
    }

    # Specify who should be notified upon success. Unfortunately it does not appear that there is currently a way to
    # automatically configure the SMTP settings through Terraform.
    notification {
        type = "on_failure" # options are "on_success", "on_failure", and "on_start"

        email {
            subject = "Rundeck job failed"
            recipients = var.notification_subscribers
            attach_log = false
        }

        #webhook_urls = var.notification_webhooks
    }
}
