variable "image_tag"      { type = string }                       # passado pela esteira
variable "lambda_role_arn"{ type = string }                       # role já existente

data "aws_caller_identity" "me" {}
data "aws_region" "cur" {}

resource "aws_ecr_repository" "lambda" {
  name = "artifact-fn"
}

resource "aws_lambda_function" "fn" {
  function_name = "artifact-fn"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lambda.repository_url}:${var.image_tag}"
  role          = var.lambda_role_arn
  architectures = ["x86_64"]    # ou ["arm64"]
  timeout       = 60
  memory_size   = 1024
}
