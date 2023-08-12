
variable "db_host" {
  type = string
  description = "The PostgreSQL database host. E.g. 192.168.0.11 or postgresql.mydomain.com"
}

variable "db_master_username" {
  type = string
  description = "The user to manage the PostgreSQL database with."
}

variable "db_master_password" {
  type = string
  description = "The password of the master user to connect to the PostgreSQL database with."
}

variable "db_port" {
  type = string
  description = "The PostgreSQL database port."
  default = 5432
}

variable "new_database_name" {
  type = string
  description = "The name to give the database we will have terraform create."
}

variable "new_database_user" {
  type = string
  description = "The name to give new role/user we will create and make the owner of the database."
}

variable "new_database_password" {
  type = string
  description = "The password for the new user/role we create."
}