terraform {
  backend "s3" {
    bucket         = "ddd-state-terraform"
    key            = "artifact-lib/terraform.tfstate"
    region         = "sa-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
