# Sobe o ZIP para o S3
resource "aws_s3_object" "artifact_lib_zip" {
  bucket = var.artifacts_bucket                     # <— só o nome do bucket
  key    = "layers/artifact-lib/layer-${var.build_id}.zip"
  source = "${path.module}/dist/layer.zip"          # <— o zip que seu build gerou
  etag   = filemd5("${path.module}/dist/layer.zip")
}

# Publica a nova versão do Layer a partir do objeto no S3
resource "aws_lambda_layer_version" "artifact_lib" {
  layer_name               = "artifact-lib"
  s3_bucket                = aws_s3_object.artifact_lib_zip.bucket
  s3_key                   = aws_s3_object.artifact_lib_zip.key
  compatible_runtimes      = ["python3.12"]
  compatible_architectures = ["x86_64", "arm64"]
  source_code_hash         = filebase64sha256("${path.module}/dist/layer.zip")
}
