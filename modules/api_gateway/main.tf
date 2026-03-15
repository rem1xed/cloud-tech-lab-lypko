
resource "aws_apigatewayv2_api" "http_api" {
  name          = "${module.this.id}-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_api" "http_api" {
  name          = "${module.this.id}-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.lambda_arn
}

resource "aws_apigatewayv2_route" "get_courses" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /courses"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "lambda_authors" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.lambda_authors_arn
}

resource "aws_apigatewayv2_route" "get_authors" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /authors"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_authors.id}"
}


resource "aws_lambda_permission" "api_gw_authors" {
  statement_id  = "AllowExecutionFromAPIGatewayAuthors"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_authors_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "save_course" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.lambda_save_course_arn
}

resource "aws_apigatewayv2_route" "post_course" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /courses"
  target    = "integrations/${aws_apigatewayv2_integration.save_course.id}"
}

resource "aws_lambda_permission" "api_gw_save" {
  statement_id  = "AllowExecutionFromAPIGatewaySave"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_save_course_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.lambda_arn
}

resource "aws_apigatewayv2_route" "get_courses" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /courses"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "lambda_authors" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.lambda_authors_arn
}

resource "aws_apigatewayv2_route" "get_authors" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /authors"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_authors.id}"
}


resource "aws_lambda_permission" "api_gw_authors" {
  statement_id  = "AllowExecutionFromAPIGatewayAuthors"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_authors_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "save_course" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.lambda_save_course_arn
}

resource "aws_apigatewayv2_route" "post_course" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /courses"
  target    = "integrations/${aws_apigatewayv2_integration.save_course.id}"
}

resource "aws_lambda_permission" "api_gw_save" {
  statement_id  = "AllowExecutionFromAPIGatewaySave"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_save_course_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}