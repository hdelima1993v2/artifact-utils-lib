output "core_layer_arn"  { value = aws_lambda_layer_version.core.arn }
output "arrow_layer_arn" { value = aws_lambda_layer_version.arrow.arn }
output "layers_arns"     { value = [aws_lambda_layer_version.core.arn, aws_lambda_layer_version.arrow.arn] }
