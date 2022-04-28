# Create a client for our user pool
# You may wish to create multiple of these, one for each site connected to your
# SSO?


resource "aws_cognito_user_pool_client" "my_user_pool_client" {
    name = var.client_name

    user_pool_id = aws_cognito_user_pool.my_user_pool.id
    generate_secret = true
    
    prevent_user_existence_errors = "ENABLED"
    enable_token_revocation = true

    # specify that the client authenticates using OAUTH code grant
    allowed_oauth_flows_user_pool_client = true

    # Use OAuth Code Flow
    # https://curity.io/resources/learn/oauth-code-flow/
    allowed_oauth_flows = ["code"]


    # Specify the auth flows. More details can be found here:
    # https://go.aws/3xZppSc
    explicit_auth_flows = [
        # Allow the application to use the refresh token to refresh the 
        # access token. This should almost always be set.
        "ALLOW_REFRESH_TOKEN_AUTH",
        
        # The following would allow the application to send the user/admins
        # password in the request to the SSO, rather than requiring the user
        # to login at the SSO UI. You want to enable these if you want
        # the user to provide their credentials at the application, but it
        # is preferable not to, and disablig these (commented oout) is certainly 
        # a requirement if the application is developed/hosted by a 3rd party.
        # "ALLOW_USER_PASSWORD_AUTH",
        # "ALLOW_ADMIN_USER_PASSWORD_AUTH"
    ]

    allowed_oauth_scopes = ["email", "openid"]

    # Set cognito itself as the only identity provider. E.g. not logging
    # in through use of facebook or google.
    supported_identity_providers = ["COGNITO"]

    # More info: https://go.aws/3OGgsTz
    callback_urls = var.client_callback_urls

    # List of allowed logout URLs for the identity providers
    logout_urls = var.client_logout_urls

    token_validity_units {
        id_token = "seconds"
        access_token = "minutes"
        refresh_token = "days"
    }

    # Number of units (from token_validity_units) that ID token is valid for
    # in this case 300 seconds or five minutes.
    id_token_validity = 300

    # Number of units (from token_validity_units) that the access token is valid 
    # for in this case 5 minutes. After this time expires, the user needs to
    # refresh the access token through the use of the refresh token.
    # One should use a short lifetime for access tokens, and a longer lifetime
    # for refresh tokens: https://www.oauth.com/oauth2-servers/access-tokens/access-token-lifetime/
    access_token_validity = 5

    # Number of units (from token_validity_units) that refresh token is valid 
    # for in this case 1 day. After this, the user will be forced to sign in 
    # again, no matter what.
    refresh_token_validity = 1
}
