output "artifact_core_layer_arn" {
  value       = aws_lambda_layer_version.artifact_lib.arn
  description = "ARN da layer artifact-lib-core"
}

output "artifact_arrow_layer_arn" {
  value       = aws_lambda_layer_version.artifact_lib_arrow.arn
  description = "ARN da layer artifact-lib-arrow"
}
 