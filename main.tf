# See here: https://docs.aws.amazon.com/secretsmanager/latest/userguide/monitoring-eventbridge.html#monitoring-eventbridge_examples-rotations
resource "aws_cloudwatch_event_rule" "secret_rotation" {
  name = "${var.name_prefix}-secret-rotation"
  event_pattern = jsonencode({
    name = var.event_rule_name

    detail-type = [
      "AWS API Call via CloudTrail",
      "AWS Service Event via CloudTrail"
    ]

    event_bus_name = var.bus_name

    detail = {
      "eventSource" : ["secretsmanager.amazonaws.com"],
      "eventName" : ["PutSecretValue", "UpdateSecret", "RotationSucceeded"]
      # See here: https://docs.aws.amazon.com/secretsmanager/latest/userguide/monitoring-eventbridge.html#monitoring-eventbridge_examples-all-changes
      "responseElements" : {
        "arn" : var.secrets_to_trigger_on
      }
    }
  })

  tags = var.event_rule_tags
}

data "archive_file" "lambda_src_code" {
  type        = "zip"
  source_file = "${path.module}/lambda/main.py"
  output_path = "${path.module}/lambda/function.zip"
}

resource "aws_lambda_function" "ecs_redeploy_lambda" {
  filename      = data.archive_file.lambda_src_code.output_path
  function_name = "${var.name_prefix}_lambda"
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
