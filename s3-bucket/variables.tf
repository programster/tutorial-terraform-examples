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

variable "bucket_name" {
    type = string
    description = "Give a name to call the bucket."
}

