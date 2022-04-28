# Outputs
# Define all the outputs of information the user needs to know. 


# Output the ID of the user pool client
output "client_id" {
    value = aws_cognito_user_pool_client.my_user_pool_client.id
}


# Output the secret for the user pool client
output "client_secret" {
    value = aws_cognito_user_pool_client.my_user_pool_client.client_secret
    sensitive=true
}