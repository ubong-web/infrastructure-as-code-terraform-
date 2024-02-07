resource "aws_apigatewayv2_api" "count-views" {
  name          = "count-views"
  protocol_type = "HTTP"

   cors_configuration {
    allow_credentials = false
    allow_origins     = ["*"]
    allow_methods     = ["GET", "POST"]
    # allow_headers     = ["content-type"]
  }
  
}
resource "aws_apigatewayv2_integration" "count-views" {
  api_id               = "${aws_apigatewayv2_api.count-views.id}"
  integration_type     = "AWS_PROXY"  # or "HTTP_PROXY" depending on your use case
  integration_method   = "POST"
  connection_type           = "INTERNET"
  description               = "Lambda example"
  integration_uri      = "${aws_lambda_function.resume-Iac.invoke_arn}"  # Replace with your new integration URI
  # passthrough_behavior = "WHEN_NO_MATCH"
}

 

resource "aws_apigatewayv2_route" "count-views" {
  api_id    = "${aws_apigatewayv2_api.count-views.id}"
  route_key = "GET /views"

  target = "integrations/${aws_apigatewayv2_integration.count-views.id}"
}
resource "aws_apigatewayv2_route" "count-views2" {
  api_id    = "${aws_apigatewayv2_api.count-views.id}"
  route_key = "POST /update"

  target = "integrations/${aws_apigatewayv2_integration.count-views.id}"
}




resource "aws_apigatewayv2_stage" "live" {
  api_id = "${aws_apigatewayv2_api.count-views.id}"
  name   = "live-stage"
  auto_deploy = "true"
  
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "resume-Iac"
  principal     = "apigateway.amazonaws.com"

  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
  source_arn = "${aws_apigatewayv2_api.count-views.execution_arn}/views"
}