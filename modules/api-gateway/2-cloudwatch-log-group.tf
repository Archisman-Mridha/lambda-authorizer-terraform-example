resource "aws_cloudwatch_log_group" "default" {
  name = "/instagram-clone-aws/apigateway/${aws_apigatewayv2_api.default.name}"

  retention_in_days = 1
}