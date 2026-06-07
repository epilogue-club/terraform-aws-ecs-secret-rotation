locals {
  app_name = "ecs-secret-rotation"
}

# See here: https://docs.aws.amazon.com/secretsmanager/latest/userguide/monitoring-eventbridge.html#monitoring-eventbridge_examples-rotations
resource "aws_cloudwatch_event_rule" "secret_rotation" {
  name = "${var.name_prefix}-secret-rotation"
  event_pattern = jsonencode({
    source = ["aws.secretsmanager"]
    # See here: https://docs.aws.amazon.com/secretsmanager/latest/userguide/monitoring-eventbridge.html#monitoring-eventbridge_examples-all-changes
    "$or" = [
      {
        detail-type = ["AWS API Call via CloudTrail"]

        detail = {
          eventSource = ["secretsmanager.amazonaws.com"]
          eventName   = ["PutSecretValue", "UpdateSecret"]
          responseElements = {
            arn = var.secrets_to_trigger_on
          }
        }
      },
      {
        detail-type = ["AWS Service Event via CloudTrail"]

        detail = {
          eventSource = ["secretsmanager.amazonaws.com"]
          eventName   = ["RotationSucceeded"]

          additionalEventData = {
            SecretId = var.secrets_to_trigger_on
          }
        }
      }
    ]
  })

  tags = var.event_rule_tags
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  arn  = aws_lambda_function.ecs_redeploy_lambda.arn
  rule = aws_cloudwatch_event_rule.secret_rotation.id
}

# See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission#basic-usage-with-eventbridge
resource "aws_lambda_permission" "execute_lambda_from_eventbridge" {
  statement_id  = "${var.name_prefix}-allow-eventbridge-invoke-lambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ecs_redeploy_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.secret_rotation.arn
}

data "archive_file" "lambda_src_code" {
  type        = "zip"
  source_file = "${path.module}/lambda/main.py"
  output_path = "${path.module}/lambda/function.zip"
}

resource "aws_lambda_function" "ecs_redeploy_lambda" {
  filename      = data.archive_file.lambda_src_code.output_path
  function_name = "${var.name_prefix}-${local.app_name}"
  description   = "Redeploys an ECS service when a secret rotation event is detected in EventBridge"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "main.lambda_handler"
  code_sha256   = data.archive_file.lambda_src_code.output_base64sha256

  runtime = "python3.14"

  environment {
    variables = {
      ECS_REGION       = var.ecs_region
      ECS_CLUSTER_NAME = var.ecs_cluster_name
      ECS_SERVICE_NAME = var.ecs_service_name
    }
  }

  tags = var.lambda_function_tags
}
