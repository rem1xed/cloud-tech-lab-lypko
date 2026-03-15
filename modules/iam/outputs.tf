output "role_arns" {
  value = { for k, v in aws_iam_role.lambda_roles : k => v.arn }
}