
variable "db_host" {
  type = string
  description = "The MySQL host. E.g. 192.168.0.11 or mysql.mydomain.com"
}

variable "db_master_username" {
  type = string
  description = "The user to manage the MySQL host with. This should probably be 'root'."
}

variable "db_master_password" {
  type = string
  description = "The password of the user we wish to use for Terraform to perform actions on the MySQL server."
}

variable "db_port" {
  type = string
  description = "The port to connect on."
  default = 3306
}

variable "new_database_name" {
  type = string
  description = "The name to give the database we will have terraform create."
}

variable "new_user" {
  type = string
  description = "The username to give new user that we will create."
}

variable "new_users_password" {
  type = string
  description = "The password for the new user we create."
}