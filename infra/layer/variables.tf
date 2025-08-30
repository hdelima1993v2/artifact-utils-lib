variable "aws_region" {
  type    = string
  default = "sa-east-1"
}

variable "layer_name" {
  type    = string
  default = "artifact-lib"
}

variable "layer_description" {
  type    = string
  default = "Layer com artifact_lib"
}

variable "artifacts_bucket" {
  type        = string
  default = "ddd-dbsource-datamesh-artifacts"
  description = "Nome do bucket S3 (na mesma região da Lambda) p/ armazenar os .zip dos layers"
}

variable build_id {
  default = "20250830-200312"
  description = "Identificador único do build (ex.: 5f3a2c1-102, 20250830-191245)"
}