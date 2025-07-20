# Artifact Utils - Lambda via Container Image

Fluxo 2-applies:
1. Primeiro `terraform apply` (placeholder) cria ECR + IAM.
2. Build & push da imagem no pipeline.
3. Segundo `terraform apply` aponta a Lambda para a imagem real.

## Estrutura
- Dockerfile
- requirements.txt
- handler.py
- src/artifact_lib/*
- infra/* (Terraform)
- .github/workflows/image-ci.yml

## Rodar local (debug)
docker build -t local-artifact:dev .
docker run -p 9000:8080 local-artifact:dev
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'

## Deploy manual (opcional)
aws ecr create-repository --repository-name artifact-lib --region sa-east-1
# login, build, push
# terraform apply -var "lambda_image_uri=<repo>:<tag>"

## Rollback
Usar tag anterior:
terraform apply -var "lambda_image_uri=<repo>:0.1.0"
