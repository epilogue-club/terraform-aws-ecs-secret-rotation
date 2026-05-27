variable "bus_name" {
  type        = string
  description = "Name of the existing EventBridge event bus"
  default     = null
}

variable "lambda_iam_role_name" {
  type        = string
  description = "Name of the existing IAM role to be used by the Lambda function"
  default     = "ecs_redeploy_lambda_exec_role"
}

variable "lambda_env_vars" {
  type        = map(string)
  description = "Environment variables to set for the Lambda function"
  default     = {}
}

variable "lambda_function_tags" {
  type        = map(string)
  description = "Tags to apply to the Lambda function"
  default     = {}
}
