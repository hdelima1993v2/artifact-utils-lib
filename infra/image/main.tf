data "aws_caller_identity" "me" {}
data "aws_region" "cur" {}

resource "aws_ecr_repository" "artifact_fn" {
  name = var.repo_name

  image_scanning_configuration { scan_on_push = true }
  encryption_configuration     { encryption_type = "AES256" }
}

resource "aws_lambda_function" "fn" {
  function_name = var.repo_name
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lambda.repository_url}:${var.image_tag}"
  role          = aws_iam_role.lambda_exec.arn
  architectures = ["x86_64"]    # ou ["arm64"]
  timeout       = 60
  memory_size   = 1024
}
