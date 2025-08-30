provider "aws" {
  region = var.aws_region
}

resource "aws_lambda_layer_version" "artifact_lib" {
  filename            = "${path.module}/../../layer.zip"
  layer_name          = var.layer_name
  description         = var.layer_description
  compatible_runtimes = ["python3.12"]
  source_code_hash    = filebase64sha256("${path.module}/../../layer.zip")
}
