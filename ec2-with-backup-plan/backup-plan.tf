# creates an IAM role with the default managed IAM Policy for allowing AWS Backup to create backups.
# requires terraform apply credentials having iam:CreateRole permissions.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection
resource "aws_iam_role" "my_iam_role_for_backups" {
  name               = "example"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

# Attach policy to allow backups to the role
resource "aws_iam_role_policy_attachment" "my_iam_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role = aws_iam_role.my_iam_role_for_backups.name
}

# Create a backup vault
resource "aws_backup_vault" "my_backup_vault" {
  name = "my_backup_vault"
}


# Create the backup plan that will schedule b ackups to happen every day at midnight
# and will retain the backups for 7 days.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan
resource "aws_backup_plan" "my_backup_plan" {
  name = "myBackupPlan"

  rule {
    rule_name = "my-backup-rule"
    schedule = "cron(0 0 * * ? *)"
    target_vault_name = aws_backup_vault.my_backup_vault.name
    
    lifecycle {
      delete_after = 7
    }
  }
}


# Assign our EC2 server to the backup plan so that it gets backed up according to the schedule/rules
resource "aws_backup_selection" "my_backup_selection" {
    name = "my-backup-plan-selection"
    iam_role_arn = aws_iam_role.my_iam_role_for_backups.arn
    plan_id = aws_backup_plan.my_backup_plan.id
    
    resources = [
      aws_instance.my_ec2_server.arn
    ]
}