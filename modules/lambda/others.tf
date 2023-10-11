variable "args" {
  type = object({
    function_name = string
    role_arn = string

    code_src_dir = string
  })
}

output "outputs" {
  value = {
    function_name = aws_lambda_function.default.function_name
    invoke_arn = aws_lambda_function.default.invoke_arn

    arn = aws_lambda_function.default.arn
  }
}