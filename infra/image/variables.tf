variable "image_tag" { 
  description = "Tag da imagem no ECR usada pela Lambda"
  type        = string
  default     = ""   # na etapa de criar/garantir o ECR não é usada
}                      

variable "repo_name" {
  type    = string
  default = "artifact-fn"
}

variable "lambda_role_arn" {
  description = "ARN da role de execução da Lambda (opcional na etapa ECR)"
  type        = string
  default     = null
}