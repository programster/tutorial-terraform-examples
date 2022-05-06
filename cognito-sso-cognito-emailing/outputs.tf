# Outputs
# Define all the outputs of information the user needs to know. 


# Output the ID of the user pool client
output "pool_id" {
    value = aws_cognito_user_pool.my_user_pool.id
}


# Output the ID of the user pool client
output "client_id" {
    value = aws_cognito_user_pool_client.my_user_pool_client.id
}


# Output the secret for the user pool client
output "client_secret" {
    value = aws_cognito_user_pool_client.my_user_pool_client.client_secret
    sensitive=true
}


# Output the endpoint for the cognito SSO.
output "sso_endpoint" {
    value = aws_cognito_user_pool.my_user_pool.endpoint
}


output "sso_auth_url" {
    value = "https://${aws_cognito_user_pool_domain.my_user_pool_domain.domain}.auth.${var.aws_region}.amazoncognito.com"
}
