resource "aws_apigatewayv2_api" "default" {
  name = "test"
  protocol_type = "HTTP"
}