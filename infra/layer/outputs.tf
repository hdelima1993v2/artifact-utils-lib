output "artifact_layer_arn" {
  value       = aws_lambda_layer_version.artifact_lib.arn
  description = "ARN da layer artifact_lib"
}
