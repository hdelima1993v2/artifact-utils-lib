provider "aws" {
  region = var.aws_region
}

resource "aws_lambda_layer_version" "shared" {
  layer_name          = var.layer_name
  description         = "${var.layer_description} (versão ${local.final_version})"
  filename            = "${path.module}/../layer.zip"
  compatible_runtimes = ["python3.11"]
  source_code_hash    = filebase64sha256("${path.module}/../layer.zip")
}

resource "aws_ssm_parameter" "layer_latest_arn" {
  name  = "/artifact-lib/layer/latest_arn"
  type  = "String"
  value = aws_lambda_layer_version.shared.arn
  overwrite = true
}
