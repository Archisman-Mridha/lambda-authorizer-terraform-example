terraform {
  required_version = ">= 1.5.3"

  backend "local" { }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.20.0"
    }

    archive = {
      source = "hashicorp/archive"
      version = "2.4.0"
    }
  }
}

provider "aws" {
  region = var.region

  access_key = var.credentials.access_key
  secret_key = var.credentials.secret_key

  default_tags {
    tags = {
      "project" = "test"
    }
  }
}

resource "aws_iam_role" "lambda" {
  name = "test-lambda-authorizer"

  assume_role_policy = <<-EOP
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
  EOP
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

module "lambda_authorizer" {
  source = "./modules/lambda"

  args = {
    function_name = "test-lambda-authorizer"
    role_arn = aws_iam_role.lambda.arn

    code_src_dir = "./lambdas/authorizer"
  }
}

module "hello_world_lambda" {
  source = "./modules/lambda"

  args = {
    function_name = "hello-world"
    role_arn = aws_iam_role.lambda.arn

    code_src_dir = "./lambdas/hello-world"
  }
}

module "api_gateway" {
  source = "./modules/api-gateway"

  args = {
    lambda_authorizer = {
      function_name = module.lambda_authorizer.outputs.function_name
      arn = module.lambda_authorizer.outputs.arn

      invoke_arn = module.lambda_authorizer.outputs.invoke_arn
    }

    route_mappings = [{
      path = "/ping"
      method = "GET"

      function_name = module.hello_world_lambda.outputs.function_name
      integration_uri = module.hello_world_lambda.outputs.invoke_arn

      protected = true
    }]
  }
}