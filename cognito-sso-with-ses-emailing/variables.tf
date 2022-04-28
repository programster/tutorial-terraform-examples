# This is the variables file. All variables that allow the administrator to customize their deployment
# should be specified here. E.g. if you wish the administrator to set the SSH key, and how many
# instances to deploy etc.

variable "aws_region" {
    type = string
    description = "The region in which the Cognito user pool will be created."
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

variable "pool_name" {
    type = string
    description = "The name you wish to give your Cognito user pool."
}

variable "client_name" {
    type = string
    description = "The name you wish to give the client of your user pool."
}

variable "password_min_length" {
    type = number
    description = "The minimum length for user passwords."
    default = 12
}

variable "password_require_lowercase" {
    type = bool
    description = "Specify whether passwords MUST have a lowercase letter."
    default = true
}

variable "password_require_numbers" {
    type = bool
    description = "Specify whether passwords MUST have contain a number."
    default = false
}

variable "password_require_symbols" {
    type = bool
    description = "Specify whether passwords MUST have contain at least one symbol."
    default = true
}

variable "password_require_uppercase" {
    type = bool
    description = "Specify whether passwords MUST have contain at least uppercase letter."
    default = true
}

variable "password_temp_validity_days" {
    type = number
    description = "Specify the number of days temporary passwords are valid for."
    default = 1
}

variable "allow_user_signup" {
    type = bool
    description = "Whether you wish to allow users to register. If false, only admins can create user accounts."
    default = false
}

variable "email_from_address" {
    type = string
    description = "Specify the email address you wish for emails to be sent from. E.g. \"john@example.com\" or \"John Smith <john@example.com>\""
}

variable "email_reply_to_address" {
    type = string
    description = "Specify the email address that you wish to act as the reply-to address. E.g. \"john@example.com\" or \"John Smith <john@example.com>\""
}

variable ses_arn {
    type = string
    description = "The ARN of the SES service which should be handling emails."
}

variable "mfa_configuration" {
    type = string
    description = "Specify if you wish to force users to use MFA (\"ON\"), prevent users from using MFA (\"OFF\"), or allow users to choose whether to use MFA (\"OPTIONAL\")."
    default = "OPTIONAL"
}

variable "client_logout_urls" {
    type = list(string)
    description = "Specify if the list of URLs that the client should support sending the user to once the user has logged out."
    default = ["http://localhost/logout-response"]
}

variable "client_callback_urls" {
    type = list(string)
    description = "Specify the list of URLs that the client should support sending the user to once they have successfully logged in. AWS Docs: https://go.aws/3OGgsTz"
    default = ["http://localhost/login-response"]
}
