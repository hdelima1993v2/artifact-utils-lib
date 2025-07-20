output "layer_version_arn" {
  value = aws_lambda_layer_version.shared.arn
}

output "layer_version_number" {
  value = aws_lambda_layer_version.shared.version
}