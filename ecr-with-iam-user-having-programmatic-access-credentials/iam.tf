# This configuration file is responsible for creating the IAM user that will have programmatic
# access to the registry.

# Create the IAM user
resource "aws_iam_user" "my_iam_user" {
  name = "my-iam-user"
}

# Create and assign the permissions policy to the user.
resource "aws_iam_user_policy" "my_user_iam_policy" {
  name = "EcrPullFromMyRegistry"
  user = aws_iam_user.my_iam_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ecr:DescribeImageScanFindings",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:DescribeImages",
                "ecr:DescribeRepositories",
                "ecr:ListTagsForResource",
                "ecr:ListImages",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetRepositoryPolicy",
                "ecr:GetLifecyclePolicy"
            ],
            "Resource": "${aws_ecr_repository.my_ecr.arn}"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "ecr:GetRegistryPolicy",
                "ecr:DescribeRegistry",
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# Create the programmatic access key for the user.
resource "aws_iam_access_key" "my_access_key" {
  user = aws_iam_user.my_iam_user.name
}

