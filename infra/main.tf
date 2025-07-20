provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "artifact_lib" {
  name                 = "artifact-lib"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.function_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "basic_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "artifact_image" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_exec.arn

  package_type  = "Image"
  image_uri     = var.lambda_image_uri

  memory_size   = var.memory_size
  timeout       = var.timeout

  environment {
    variables = {
      APP_ENV = "prod"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.basic_logs,
    aws_ecr_repository.artifact_lib
  ]
}
