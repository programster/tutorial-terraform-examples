terraform {
  required_providers {
    mysql = {
      source = "petoju/mysql"
      version = "3.0.47"
    }
  }
}


# Create the MySQL provider with the connection details.
provider "mysql" {
  endpoint = "${var.db_host}:${var.db_port}"
  username = var.db_master_username
  password = var.db_master_password
}


# Create a database that will be owned by our newly created user.
resource "mysql_database" "my_database" {
  name                  = var.new_database_name
  default_character_set = "utf8mb4"
  default_collation     = "utf8mb4_general_ci"
}

# Create our new user.
resource "mysql_user" "my_user" {
  user               = var.new_user
  host               = "%" // allow this user to connect from anywhere. You may wish to swap with "localhost" or an IP.
  plaintext_password = var.new_users_password
}

# Grant our new user full access to our new database
resource "mysql_grant" "my_grant" {
  user       = mysql_user.my_user.user
  host       = mysql_user.my_user.host
  database   = mysql_database.my_database.name
  privileges = ["ALL"] // may wish to refer here for list of possible privileges: https://bit.ly/3OtR7O6
}