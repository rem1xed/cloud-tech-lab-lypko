resource "aws_lambda_function" "lambda" {
  function_name = var.function_name
  role          = var.role_arn
  filename      = var.filename
  handler       = var.handler
  runtime       = var.runtime
  source_code_hash = var.source_code_hash
  environment {
    variables = {
      COURSES_TABLE = var.courses_table_name
      AUTHORS_TABLE = var.authors_table_name
    }
  }
}
