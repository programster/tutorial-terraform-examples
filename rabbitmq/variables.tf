
variable "rabbitmq_host" {
  type = string
  description = "The RabbitMQ host. E.g. http://192.168.0.11 or https://rabbitmq.mydomain.com. Be sure to include http:// or https://"
}

variable "rabbitmq_master_username" {
  type = string
  description = "The user to manage the MySQL host with. This should probably be 'root'."
}

variable "rabbitmq_master_password" {
  type = string
  description = "The password of the user we wish to use for Terraform to perform actions on the MySQL server."
}

variable "rabbitmq_port" {
  type = string
  description = "The port to connect on."
  default = 5672
}


variable "new_vhost_name" {
    type = string
    description = "The name to give the virtual host we will have terraform create."
}

variable "new_queue_name" {
  type = string
  description = "The name to give the queue we will have terraform create."
}

variable "new_exchange_name" {
    type = string
    description = "The name to give the exchange we will have terraform create."
}

variable "new_user" {
  type = string
  description = "The username to give new user that we will create."
}

variable "new_users_password" {
  type = string
  description = "The password for the new user we create."
}

variable "new_users_tags" {
    type = list
    description = "Tags to set for the user."
}