variable "aws_region" {
  type    = string
  default = "sa-east-1"
}

variable "function_name" {
  type    = string
  default = "artifact-lib-func"
}

variable "memory_size" {
  type    = number
  default = 1024
}
   
variable "timeout" {
  type    = number
  default = 30
}

variable "lambda_image_uri" {
  type        = string
  description = "URI completo da imagem ECR (repo:tag)"
}
