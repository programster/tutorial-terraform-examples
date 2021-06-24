# Outputs
# Define all the outputs of information the user needs to know.

# Output the registry we created that you can pull/push to
output "my_ecr_url" {
    value = aws_ecr_repository.my_ecr.repository_url
}

# Output the IAM users key
output "my_iam_user_key" {
  value = aws_iam_access_key.my_access_key.id
  sensitive = true
}

# Output the IAM users secret
output "my_iam_user_secret" {
  value = aws_iam_access_key.my_access_key.secret
  sensitive = true
}
