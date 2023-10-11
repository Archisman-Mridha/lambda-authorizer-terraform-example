output "outputs" {
  value = {
    api_gateway_invoke_url = module.api_gateway.outputs.invoke_url
  }
}