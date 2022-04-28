# This is the variables file. All variables that allow the administrator to customize their deployment
# should be specified here. E.g. if you wish the administrator to set the SSH key, and how many
# instances to deploy etc.

variable "aws_region" {
    type = string
    description = "Provide the region you wish to deploy to."
    default = "eu-west-2"
}

variable "access_key" {
    type = string
    description = "The access key for Terraform to use for deploying AWS infrastructure."
}

variable "secret_key" {
    type = string
    description = "The secret key for Terraform to use for deploying AWS infrastructure."
}

variable "registry_name" {
    type = string
    description = "Provide the name for the registry you wish to create."
}
