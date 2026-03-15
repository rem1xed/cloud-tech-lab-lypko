resource "aws_lambda_function" "lambda" {
  function_name = var.function_name
  role          = var.role_arn
  filename      = var.filename
  handler       = var.handler
  runtime       = var.runtime
}