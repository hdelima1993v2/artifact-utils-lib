data "aws_caller_identity" "cur" {}
data "aws_region"          "cur" {}

# Upload dos ZIPs (core e arrow)
resource "aws_s3_object" "core_zip" {
  bucket = var.artifacts_bucket
  key    = "layers/${var.layer_name}-core/${var.build_id}.zip"
  source = "${path.module}/dist/core_layer.zip"
  etag   = filemd5("${path.module}/dist/core_layer.zip")
}

resource "aws_s3_object" "arrow_zip" {
  bucket = var.artifacts_bucket
  key    = "layers/${var.layer_name}-arrow/${var.build_id}.zip"
  source = "${path.module}/dist/arrow_layer.zip"
  etag   = filemd5("${path.module}/dist/arrow_layer.zip")
}

# Publicação dos Lambda Layers
resource "aws_lambda_layer_version" "core" {
  layer_name          = "${var.layer_name}-core"
  description         = "${var.layer_description} (core)"
  s3_bucket           = aws_s3_object.core_zip.bucket
  s3_key              = aws_s3_object.core_zip.key
  compatible_runtimes = ["python3.12"]
}

resource "aws_lambda_layer_version" "arrow" {
  layer_name          = "${var.layer_name}-arrow"
  description         = "${var.layer_description} (arrow)"
  s3_bucket           = aws_s3_object.arrow_zip.bucket
  s3_key              = aws_s3_object.arrow_zip.key
  compatible_runtimes = ["python3.12"]
}
