terraform {
  required_providers {
    postgresql = {
      source = "cyrilgdn/postgresql"
      version = "1.17.1"
    }
  }
}


# Create the PostgreSQL provider with the connection details.
provider "postgresql" {
  host = var.db_host
  port = var.db_port

  username = var.db_master_username
  password = var.db_master_password

  sslmode = "disable"

  # The first/master user is a superuser - https://go.aws/43YExvq
  # With RDS instances this needs to be set to false for some reason.
  # I need to dig further into this.
  superuser = true
}


# Create a new user on the database.
resource "postgresql_role" "my_role" {
  name                = var.new_database_user
  login               = true
  password            = var.new_database_password
  encrypted_password  = true
}


# Create a database that is owned by our newly created user.
resource "postgresql_database" "my_database" {
  name              = var.new_database_name
  owner             = var.new_database_user
  template          = "template0"
  connection_limit  = -1 #  means no limit
  allow_connections = true
  encoding          = "UTF8"
}


# Install the btree_gist extension on the database.
# This extension is required for more advanced constraints - https://bit.ly/41CFKHD
resource "postgresql_extension" "my_btree_gist_extension" {
  name = "btree_gist"
  database = var.new_database_name
  depends_on = [postgresql_database.my_database]
}