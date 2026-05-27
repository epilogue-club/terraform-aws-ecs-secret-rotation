variable "bus_name" {
  type        = string
  description = "Name of the existing EventBridge event bus"
  default     = null
}

variable "event_rule_name" {
  type        = string
  description = "Name of the EventBridge rule to be created"
  default     = null
}

variable "secrets_to_trigger_on" {
  type        = list(string)
  description = "List of secret ARNs that should trigger the redeploy when rotated"
  default     = []
}

variable "event_rule_tags" {
  type        = map(string)
  description = "Tags to apply to the EventBridge rule"
  default     = {}
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
