# Create a parameter group which will be used by the RDS.
# You may wish to refer the the aws list of parameters for PostgreSQL
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.Parameters.html
# or the Terraform docs for parameter groups:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group
resource "aws_db_parameter_group" "my_parameter_group" {
    name    = var.db_parameter_group_name
    family  = "postgres14"

    parameter {
        name  = "client_encoding"
        value = "utf8"
    }
}


# Create a datbase subnet group for assigning the RDS to.
resource "aws_db_subnet_group" "my_rds_subnet_group" {
    name       = "main"
    subnet_ids = [aws_subnet.my_vpc_subnet.id, aws_subnet.my_vpc_subnet2.id, aws_subnet.my_vpc_subnet2.id]

    tags = {
        Name = "My DB subnet group"
    }
}


# Create the RDS instance, using the parameter group we created earlier.
resource "aws_db_instance" "my_db_instance" {
    db_name              = var.db_name
    engine               = "postgres"
    engine_version       = var.db_engine_version
    instance_class       = var.db_instance_size
    identifier           = var.db_identifier
    username             = var.db_username
    password             = var.db_password
    port                 = var.db_port
    parameter_group_name = aws_db_parameter_group.my_parameter_group.name    
    publicly_accessible  = true
    performance_insights_enabled = false

    # Networking / VPC stuff
    availability_zone       = "${var.aws_region}${var.db_availability_zone_letter}"
    multi_az                = var.db_multi_az
    vpc_security_group_ids  = [aws_security_group.my_vpc_security_group.id]
    db_subnet_group_name    = aws_db_subnet_group.my_rds_subnet_group.name

    # Indicates that minor engine upgrades will be applied automatically to the 
    # DB instance during the maintenance window. Defaults to true, but good
    # to explicitly set this
    auto_minor_version_upgrade = true

    # Define disk storage type
    # "standard" - magnetic
    # "gp2" - general purpose SSD
    # "io1" - provisioned IOPS SSD.
    storage_type = var.db_storage_type

    # Configure amount of storage. You may wish to read up on autoscaled
    # storage at: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PIOPS.StorageTypes.html
    # which tells you when storage will be increased, and by how much.
    allocated_storage     = var.db_inital_allocated_storage
    max_allocated_storage = var.db_max_allowed_storage

    # Configure to NOT skip the final snapshot. Thus if one was to accidentally
    # nuke one's database, one can still retrieve the data. If you don't want
    # it, then simply delete the snapshot.
    skip_final_snapshot  = false
    final_snapshot_identifier = "final-${var.db_name}"

    # Enable deletion protection, to prevent accidentally nuking the instance.
    # Thus, in order to do so, the administrator would need to manually flip
    # this to false and apply before running the terraform destroy.
    deletion_protection = true

    # Specify that storage is encrypted. If you are creating a cross-region read
    # replica this field is ignored and you should instead declare 
    # kms_key_id with a valid ARN.
    storage_encrypted = true

    # The window to perform maintenance in.
    # Syntax: "ddd:hh24:mi-ddd:hh24:mi". Eg: "Mon:00:00-Mon:03:00"
    maintenance_window = var.db_maintenance_window

    # Specify backup options.
    backup_window = var.db_backup_window
    backup_retention_period = var.backup_retention_period

    # Specifies whether to remove automated backups immediately after the
    # database is deleted. The default is true. Don't forget that we have
    # deletion_protection enabled and skip_final_snapshot set to false.
    delete_automated_backups = true
}