resource "aws_iam_role" "lambda_exec_role" {
  name               = "${var.name_prefix}-${var.lambda_iam_role_name}"
  assume_role_policy = data.aws_iam_policy_document.lambda_exec_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_exec_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_exec_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "ecs:UpdateService"
    ]

    resources = [var.ecs_service_arn]
    sid       = "UpdateEcsService"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_exec_role_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = data.aws_iam_policy_document.lambda_exec_role_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
