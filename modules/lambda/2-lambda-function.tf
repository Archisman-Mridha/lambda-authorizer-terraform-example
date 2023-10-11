resource "aws_lambda_function" "default" {
  function_name = var.args.function_name

  // IAM role that grants the function permission to access AWS services and resources. When you
  // invoke your function, Lambda automatically provides your function with temporary credentials by
  // assuming this role.
  role = var.args.role_arn

  runtime = "go1.x"
  architectures = [ "x86_64" ] // Currently the Lambda runtime for GoLang doesn't support arm64
                               // architecture.
  memory_size = 128

  package_type = "Zip"
  filename = data.archive_file.default.output_path
  handler = var.args.function_name

  // To trigger re-deployment of this resource when the zip file (containing the application build)
  // changes.
  source_code_hash = data.archive_file.default.output_base64sha256

  skip_destroy = false
}