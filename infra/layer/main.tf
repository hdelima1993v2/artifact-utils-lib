# 1) Suba o ZIP do layer para S3 (pode ser via pipeline ou aws_s3_object)
resource "aws_s3_object" "artifact_lib_zip" {
  bucket = var.artifacts_bucket
  key    = "layers/artifact-lib/layer-${var.build_id}.zip"
  source = "${path.module}/dist/layer.zip"
  etag   = filemd5("${path.module}/dist/layer.zip")
}

# 2) Publique o layer usando o objeto no S3 (evita o limite do corpo da requisição)
resource "aws_lambda_layer_version" "artifact_lib" {
  layer_name               = "artifact-lib"
  s3_bucket                = aws_s3_object.artifact_lib_zip.bucket
  s3_key                   = aws_s3_object.artifact_lib_zip.key
  compatible_runtimes      = ["python3.12"]
  compatible_architectures = ["x86_64", "arm64"]
  # mantém detecção de mudanças no ZIP local (opcional se já usa aws_s3_object)
  source_code_hash         = filebase64sha256("${path.module}/dist/layer.zip")
}
