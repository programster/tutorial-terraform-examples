
variable "rundeck_url" {
  type = string
  description = "The locaton of the Rundeck host. E.g. http://127.0.0.1:4440/ or https://rundeck.mydomain.com/"
}

variable "rundeck_auth_username" {
  type = string
  description = "The username for Terraform/Tofu to connect to Rundeck with."
}

variable "rundeck_auth_password" {
  type = string
  description = "The password for Terraform/Tofu to connect to Rundeck with."
}

variable "ssh_private_key" {
  type = string
  description = "A private key to add to Rundeck for it to be able to SSH into your remote servers. The corresponding SSH username should be specified in the nodes configuration."
}

variable "project_label" {
  type = string
  description = "A name to give the project. E.g. 'My Project'"
  default = "My Project"
}

variable "project_slug_name" {
  type = string
  description = "A 'slug' name to give the project. This is  This cannot have spaces, but can have underscores. E.g. 'my_project'."
  default = "my_project"
}

variable notification_subscribers {
  type = list
  description = "A list of emails to send notifications to when a job fails. E.g. [\"my.email@gmail.com\"]"
  default = []
}

variable notification_webhooks {
  type = list
  description = "A list of URLs to hit for when notifications are triggered."
  default = []
}

variable my_secret_value {
    type = string
    description = "Some secret that needs to be kept safe, such as a bearer token or password."
}



