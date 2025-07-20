output "ecr_repository_url" {
  value       = aws_ecr_repository.artifact_lib.repository_url
  description = "URL do repositório ECR (use para build da imagem)."
}

output "lambda_name" {
  value       = local.valid_image ? aws_lambda_function.artifact_image[0].function_name : null
  description = "Nome da Lambda (null enquanto placeholder)."
}

output "lambda_image_uri_applied" {
  value       = local.valid_image ? aws_lambda_function.artifact_image[0].image_uri : null
  description = "Image URI aplicado (null enquanto placeholder)."
}
