data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals { 
        type = "Service" 
        identifiers = ["lambda.amazonaws.com"] 
        }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name               = "artifact-image-exec"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

# Logs básicos
resource "aws_iam_role_policy_attachment" "cwlogs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# (adicione anexos extras aqui conforme sua função precisar)

# Use essa role na Lambda
# artifact-utils-lib/infra/image/main.tf
# role = aws_iam_role.lambda_exec.arn
