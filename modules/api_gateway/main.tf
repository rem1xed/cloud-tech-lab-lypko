module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = module.this.context
}

resource "aws_apigatewayv2_api" "http_api" {
  name          = "${module.label.id}-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_headers = ["content-type", "authorization", "x-amz-date", "x-api-key", "x-amz-security-token"]
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda" {
  for_each         = var.lambda_arns
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = each.value
}

locals {
  routes = {
    "GET /authors"      = "get_authors"
    "GET /courses"      = "get_courses"
    "POST /courses"     = "save_course"
    "GET /courses/{id}" = "get_course"
    "PUT /courses/{id}" = "update_course"
    "DELETE /courses/{id}" = "delete_course"
  }
}

resource "aws_apigatewayv2_route" "routes" {
  for_each = local.routes
  api_id   = aws_apigatewayv2_api.http_api.id
  route_key = each.key
  target    = "integrations/${aws_apigatewayv2_integration.lambda[each.value].id}"
}

resource "aws_lambda_permission" "api_gw" {
  for_each      = var.lambda_arns
  statement_id  = "AllowExecutionFromAPIGateway-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}