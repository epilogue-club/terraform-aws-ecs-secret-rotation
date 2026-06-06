output "event_rule_arn" {
  description = "ARN of the CloudWatch Event Rule that triggers the Lambda function on secret rotation events"
  value       = aws_cloudwatch_event_rule.secret_rotation.arn
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function that will be triggered on secret rotation events"
  value       = aws_lambda_function.ecs_redeploy_lambda.arn
}

output "iam_role_arn" {
  description = "ARN of the IAM role assumed by the Lambda function"
  value       = aws_iam_role.lambda_exec_role.arn
}
