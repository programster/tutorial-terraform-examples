## Terraform Examples
This repository contains examples of Terraform deployments.
Simply navigate into one of the relevant example directory and run the instruction steps listed below.

These examples demonstrate:

* The ability to break up configuration over multiple files
* The ability to deploy EC2 on its own
* The ability to deploy multiple EC2s as part of an autoscaling group and load balancer.
* How to make use of variables.
* The use of a cloud-init configuration to setup EC2 once its deployed (pulling and deploying a Docker image for a webserver).
* The ability to perform variable substitution into the cloud init script.


## Instructions
1. Checkout the code

2. Copy the `terraform.tfvars.example` file to `terraform.tfvars` and plug in your public SSH key.

3. Create an IAM user that has full access to the EC2 service, and run the following command to provide terraform with the credentials to use:

```bash
export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=xxx
```

4. Run `terraform init` from inside the `/terraform` directory

5. Run `terraform plan` to have Terraform check everything is good and tell you what it intends to do.

6. Run `terraform apply` to have Terraform perform the deployment (you will have to confirm by typing `yes`).

7. Wait for Terraform to deploy, and look at the results in the web console.

8. Make a note of the outputs. E.g. `load_balancer_url`, `simple_server_ip`, and `web_port`.

9. Check that you can hit the deployed EC2 server (`simple_server_ip`) using the `web_port` specified.

10. Check that you can hit the servers behind the load balancer by hitting the outputted `load_balancer_url` (along with the `web_port`), in your browser

11. Run `terraform destroy` to spin everything down again.


## Misc
Initially, I used t2.micro instances for these examples, but they deploy so slowly that it makes it appear that
this doesn't work. Changing to a t3a.micro instance makes a HUGE difference, and still only
costs pennies if you destroy everything (`terraform destroy`) within minutes.

### Terraform Lock File
The `.terraform.lock.hcl` lock file is in the `.gitignore` file as this codebase
is supposed to be a template for others and I don't wish to accidentally commit my lock file.
When creating a project from this codebase, be sure to remove this and commit the `.terraform.lock.hcl`
to your codebase. Terraform explicitly tells you to do this with the following message:

> Terraform has created a lock file .terraform.lock.hcl to record the provider selections it made
above. Include this file in your version control repository so that Terraform can guarantee to make
the same selections by default when you run "terraform init" in the future.
