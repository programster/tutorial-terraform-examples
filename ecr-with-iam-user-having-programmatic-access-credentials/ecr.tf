# Create an elastic container registry
resource "aws_ecr_repository" "my_ecr" {
    name = var.registry_name
}