locals {
  permissions = {
    get_authors   = { action = "dynamodb:Scan",       resource = var.authors_table_arn }
    get_courses   = { action = "dynamodb:Scan",       resource = var.courses_table_arn }
    get_course    = { action = "dynamodb:GetItem",    resource = var.courses_table_arn }
    save_course   = { action = "dynamodb:PutItem",    resource = var.courses_table_arn }
    update_course = { action = "dynamodb:PutItem",    resource = var.courses_table_arn }
    delete_course = { action = "dynamodb:DeleteItem", resource = var.courses_table_arn }
  }
}

resource "aws_iam_role" "lambda_roles" {
  for_each = local.permissions
  name     = "${var.namespace}-${var.stage}-${each.key}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "dynamodb_limit" {
  for_each = local.permissions
  name     = "DynamoDBAccess"
  role     = aws_iam_role.lambda_roles[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [each.value.action]
        Effect   = "Allow"
        Resource = each.value.resource
      },
      {
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}