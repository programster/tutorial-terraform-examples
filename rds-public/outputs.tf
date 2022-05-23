# output the address of the db (e.g. where to connect)
output "rds_address" {
    value = aws_db_instance.my_db_instance.address
}

output "db_username" {
    value = var.db_username
}

output "db_password" {
    value = var.db_password
}

output "port" {
    value = var.db_port
}

output "database_name" {
    value = var.db_name
}
