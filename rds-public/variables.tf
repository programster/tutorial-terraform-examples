variable "aws_region" {
    type = string
    description = "The region to deploy to. E.g. eu-west-2 for London."
    default = "eu-west-2"
}


variable "availability_zone_prefix" {
    type = string
    description = "The prefix for the availability zones. This is related to the aws_region. E.g. if aws_region is 'eu-west-2', then this would be 'euw2'."
    default = "euw2"
}


variable "access_key" {
    type = string
    description = "The access key for Terraform to use for deploying AWS infrastructure."
}

variable "secret_key" {
    type = string
    description = "The secret key for Terraform to use for deploying AWS infrastructure."
}

variable "vpc_name" {
    type = string
    description = "Specify a name to give the VPC that will be created to hold your RDS instance."
}

variable "db_parameter_group_name" {
    type = string
    description = "Specify the name for the parameter group that will be created and assigned to your database."
}

variable "db_name" {
    type = string
    description = "The name to give the database that will run inside the RDS instance. E.g. the value you will pass to '-d' when connecting with the psql CLI."
}

variable "db_identifier" {
    type = string
    description = "Specify an identifier for the database. This needs to be unique and will form part of the outputted DNS address that one will connect to. Only lowercase alphanumeric characters and hyphens allowed."
}

variable "db_instance_size" {
    type = string
    description = "Specify the instance size to deploy for the database. Refer here: https://aws.amazon.com/rds/instance-types/"
    default = "db.t3.micro"
}

variable "db_username" {
    type = string
    description = "The username for the master user of the database."
}

variable "db_password" {
    type = string
    description = "The password for the master user of the database."
}

variable "db_inital_allocated_storage" {
    type = number
    description = "Specify how many GB you wish to be allocated for the RDS upon deployment."
    default = 10
}

variable "db_max_allowed_storage" {
    type = number
    description = "Specify how many GB you would like to allow AWS to expand your RDS to as it runs out of storage. This is for storage autoscaling: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PIOPS.StorageTypes.html"
    default = 100
}

# Define disk storage type
# "standard" - magnetic
# "gp2" - general purpose SSD
# "io1" - provisioned IOPS SSD.
variable "db_storage_type" {
    type = string
    description = "Define disk storage type. \"standard\" = magnetic. \"gp2\" - general purpose SSD. \"io1\" = provisioned IOPS SSD."
    default = "gp2"
}

variable "db_apply_changes_immediately" {
    type = bool
    description = "Specify whether to apply changes immediately (true) or to apply during the next maintenance window (false)."
    default = true
}

variable "db_port" {
    type = number
    description = "Specify the port the database should be accessible on."
    default = 5432
}

variable "db_availability_zone_letter" {
    type = string
    description = "Specify the availability zone letter the database should be deployed to. This relates to the aws_region variable. E.g. specify \"a\", \"b\" or \"c\""
    default = "a"
}

variable "db_engine_version" {
    type = string
    description = "Specify the engine version the database should use."
    default = "14.2"
}

variable "db_maintenance_window" {
    type = string
    description = "The window to perform maintenance in. Syntax: \"ddd:hh24:mi-ddd:hh24:mi\". Eg: \"Mon:00:00-Mon:03:00\"."
    default = "Sun:01:00-Sun:04:00"
}

variable "db_backup_window" {
    type = string
    description = "Specify the daily time range (in UTC) during which automated backups are created if they are enabled. Must not overlap with db_maintenance_window."
    default = "00:00-01:00"
}

variable "backup_retention_period" {
    type = number
    description = "Specity the number of days to retain backups for. Must be between 0 and 35."
    default = "35"
}

variable "db_multi_az" {
    type = bool
    description = "Specify if the database should be multi-AZ."
    default = false
}

