resource "null_resource" "builder" {
  provisioner "local-exec" {
    command = <<-EOC
      cd ${var.args.code_src_dir} && \
        GOARCH=amd64 GOOS=linux go build -o build/${var.args.function_name}
    EOC

    when = create
    on_failure = fail
  }

  triggers = {
    current_time = timestamp( )
  }
}

data "archive_file" "default" {
  type = "zip"

  source_dir = "${var.args.code_src_dir}/build"
  output_path = "outputs/lambda-archives/${var.args.function_name}.zip"

  depends_on = [ null_resource.builder ]
}