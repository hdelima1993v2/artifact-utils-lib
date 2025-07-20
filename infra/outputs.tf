output "ecr_repository_url" {
  value       = aws_ecr_repository.artifact_lib.repository_url
  description = "URL do ECR repository"
}

output "lambda_name" {
  value       = aws_lambda_function.artifact_image.function_name
  description = "Nome da Lambda"
}

output "lambda_image_uri_applied" {
  value       = aws_lambda_function.artifact_image.image_uri
  description = "Image URI aplicado"
}
