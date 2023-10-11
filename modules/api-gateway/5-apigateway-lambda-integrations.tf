resource "aws_apigatewayv2_integration" "integrations" {
  count = length(var.args.route_mappings)

  api_id = aws_apigatewayv2_api.default.id

  connection_type = "INTERNET"
  integration_type = "AWS_PROXY"
  integration_method = "POST"

  integration_uri = var.args.route_mappings[count.index].integration_uri
}

resource "aws_apigatewayv2_route" "routes" {
  count = length(var.args.route_mappings)

  api_id = aws_apigatewayv2_api.default.id

  route_key = "${var.args.route_mappings[count.index].method} ${var.args.route_mappings[count.index].path}"
  target = "integrations/${aws_apigatewayv2_integration.integrations[count.index].id}"

  authorization_type = var.args.route_mappings[count.index].protected ? "CUSTOM" : "NONE"
  authorizer_id = var.args.route_mappings[count.index].protected ? aws_apigatewayv2_authorizer.default.id : null
}

resource "aws_lambda_permission" "lambda_permissions" {
  count = length(var.args.route_mappings)

  statement_id = "AllowLambdaExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = var.args.route_mappings[count.index].function_name

  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.default.execution_arn}/*/*"
}