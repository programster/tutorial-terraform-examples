# This is the variables file. All variables that allow the administrator to customize their deployment
# should be specified here. E.g. if you wish the administrator to set the SSH key, and how many
# instances to deploy etc.

variable "ssh_public_key" {
    type = string
    description = "The public key that corresponds to the private SSH key you would want to use to log into the EC2 instances with, should you need to. Should start like 'ssh-rsa AAAA...'"
}

variable "aws_region" {
    type = string
    description = "The region to deploy to. E.g. eu-west-2 for London."
    default = "eu-west-2"
}

variable "ami" {
    type = string
    description = "The AMI ID to deploy for the server. This AMI needs to be available in the region specified earlier."
    default = "ami-05c424d59413a2876"
}

variable "certificate_arn" {
    type = string
    description = "Provide the ARN of the SSL certificate to assign to your load balancer. This certificate needs to be in the same region and be 2048 bit or less."
}