variable "args" {
  type = object({

    lambda_authorizer = object({
      function_name = string
      arn = string

      invoke_arn = string
    })

    route_mappings = list(object({
      path = string
      method = string

      function_name = string
      integration_uri = string

      protected = bool
    }))
  })
}

output "outputs" {
  value = {
    invoke_url = aws_apigatewayv2_stage.test.invoke_url
  }
}