variable "aws_region" {
  type    = string
  default = "sa-east-1"
}

variable "layer_name" {
  type    = string
  default = "artifact-lib-layer"
}

variable "layer_description" {
  type    = string
  default = "Biblioteca compartilhada única (single env)"
}
