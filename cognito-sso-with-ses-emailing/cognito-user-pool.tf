# Create the cognito user pool
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool

resource "aws_cognito_user_pool" "my_user_pool" {
    name = var.pool_name

    schema {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "email"
        required                 = true

        string_attribute_constraints {
            min_length = 1
            max_length = 256
        }
    }

    # specify that usernames are not case sensitive, as using email address,
    # which ideally should not be case sensitive.
    username_configuration {
        case_sensitive = false
    }

    mfa_configuration = var.mfa_configuration

    # Use software based MFA (e.g. google authenticator)
    software_token_mfa_configuration {
        enabled = true
    }

    # If you want SMS based MFA, you would need to uncommend and configure
    # this block.
    #sms_configuration {
    #    external_id    = "example"
    #    sns_caller_arn = aws_iam_role.example.arn
    #}

    # Specify attributes you wish to automatically trigger verification for
    # This is not a list of attributes to be automatically marked as verified.
    # https://stackoverflow.com/questions/59935728/creating-aws-cognito-user-pool-using-terraform-disables-email-validation
    auto_verified_attributes = ["email"]

    admin_create_user_config {
        allow_admin_create_user_only = !var.allow_user_signup
    }

    # Allow remembering the users device if the user opts in. 
    # Remove this block if you don't want to allow remembering devices.
    # Set device_only_remembered_on_user_prompt to false if you *always* want to 
    # remember the users device.
    device_configuration {
        device_only_remembered_on_user_prompt = true
    }

    account_recovery_setting {

        recovery_mechanism {
            name     = "verified_email"
            priority = 1
        }
    }

    email_configuration {
        email_sending_account = "DEVELOPER" # use this for SES
        source_arn = var.ses_arn
        from_email_adress = var.email_from_address
        reply_to_email_adress = var.email_reply_to_address
    }

    password_policy {
        minimum_length = var.password_min_length
        require_lowercase = var.password_require_lowercase
        require_numbers = var.password_require_numbers
        require_symbols = var.password_require_symbols
        require_uppercase = var.password_require_uppercase
        temporary_password_validity_days = var.password_temp_validity_days
    }
}


# Create a domain in Cognito for users to sign in at. 
resource "aws_cognito_user_pool_domain" "my_user_pool_domain" {

    # Set the part of the domain that you can control. E.g. this will be
    # {var.user_pool_auth_subdomain}.auth.{region}.amazoncongito.com
    domain       = var.user_pool_auth_subdomain

    user_pool_id = aws_cognito_user_pool.my_user_pool.id
}
