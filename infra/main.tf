terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {
  region = "sa-east-1"
}

variable "build_id"         { type = string }
variable "artifacts_bucket" { type = string }

# ---------- LAYER CORE (awswrangler + pandas + numpy + sua lib) ----------
resource "aws_s3_object" "artifact_lib_zip" {
  bucket = var.artifacts_bucket
  key    = "layers/artifact-lib-core/layer-${var.build_id}.zip"
  source = "${path.module}/dist/core_layer.zip"
  etag   = filemd5("${path.module}/dist/core_layer.zip")
}

resource "aws_lambda_layer_version" "artifact_lib" {
  layer_name               = "artifact-lib-core"
  s3_bucket                = aws_s3_object.artifact_lib_zip.bucket
  s3_key                   = aws_s3_object.artifact_lib_zip.key
  compatible_runtimes      = ["python3.12"]
  compatible_architectures = ["x86_64"]  # binários foram compilados para x86_64
  source_code_hash         = filebase64sha256("${path.module}/dist/core_layer.zip")
}

# ---------- LAYER ARROW (pyarrow) ----------
resource "aws_s3_object" "artifact_lib_arrow_zip" {
  bucket = var.artifacts_bucket
  key    = "layers/artifact-lib-arrow/layer-${var.build_id}.zip"
  source = "${path.module}/dist/arrow_layer.zip"
  etag   = filemd5("${path.module}/dist/arrow_layer.zip")
}

resource "aws_lambda_layer_version" "artifact_lib_arrow" {
  layer_name               = "artifact-lib-arrow"
  s3_bucket                = aws_s3_object.artifact_lib_arrow_zip.bucket
  s3_key                   = aws_s3_object.artifact_lib_arrow_zip.key
  compatible_runtimes      = ["python3.12"]
  compatible_architectures = ["x86_64"]
  source_code_hash         = filebase64sha256("${path.module}/dist/arrow_layer.zip")
}
