resource "aws_apigatewayv2_authorizer" "default" {
  api_id = aws_apigatewayv2_api.default.id
  name = "test"

  authorizer_type = "REQUEST"
  authorizer_payload_format_version = "2.0"

  authorizer_uri = var.args.lambda_authorizer.invoke_arn
  identity_sources = [ "$request.header.Authorization" ]

  authorizer_result_ttl_in_seconds = 300

  enable_simple_responses = true
}

resource "aws_lambda_permission" "lambda_authorizer" {
  statement_id = "AllowLambdaExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = var.args.lambda_authorizer.function_name

  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.default.execution_arn}/authorizers/${aws_apigatewayv2_authorizer.default.id}"
}