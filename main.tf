# See here: https://docs.aws.amazon.com/secretsmanager/latest/userguide/monitoring-eventbridge.html#monitoring-eventbridge_examples-rotations
resource "aws_cloudwatch_event_rule" "secret-rotation" {
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

data "aws_iam_policy_document" "lambda_exec_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name               = var.lambda_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.lambda_exec_role_policy.json
}

data "archive_file" "lambda_src_code" {
  type        = "zip"
  source_file = "${path.module}/lambda/main.py"
  output_path = "${path.module}/lambda/function.zip"
}

resource "aws_lambda_function" "ecs_redeploy_func" {
  filename      = data.archive_file.lambda_src_code.output_path
  function_name = "ecs_redeploy_on_secret_rotation"
  description   = "Redeploys an ECS service when a secret rotation event is detected in EventBridge"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "main.lambda_handler"
  code_sha256   = data.archive_file.lambda_src_code.output_base64sha256

  runtime = "python3.14"

  environment {
    variables = var.lambda_env_vars
  }

  tags = var.lambda_function_tags
}
