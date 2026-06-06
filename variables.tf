# This needs to be required in case a user has multiple instances of this module
variable "name_prefix" {
  type        = string
  description = "Prefix to use for naming AWS resources created by this module"

  validation {
    # Setting 44 as the max length for lambda function names are 64 chars and we're using 20 chars for the suffix
    condition     = length(var.name_prefix) > 0 && length(var.name_prefix) <= 44
    error_message = "name_prefix must be between 1 and 44 characters inclusive"
  }
}

variable "bus_name" {
  type        = string
  description = "Name of the existing EventBridge event bus"
  default     = null
}

variable "secrets_to_trigger_on" {
  type        = list(string)
  description = "List of secret ARNs that should trigger the redeploy when rotated"

  validation {
    condition     = length(var.secrets_to_trigger_on) > 0
    error_message = "You need to provide at least one secret ARN in the secrets_to_trigger_on variable."
  }
}

variable "event_rule_tags" {
  type        = map(string)
  description = "Tags to apply to the EventBridge rule"
  default     = {}
}

variable "lambda_iam_role_name" {
  type        = string
  description = "What to name the IAM role to be used by the Lambda function"
  # Do not include a prefix here
  default = "lambda-exec-role"
}

variable "ecs_region" {
  type        = string
  description = "AWS region where the ECS cluster is located"
}

variable "ecs_cluster_name" {
  type        = string
  description = "The name of the ECS cluster containing the service to redeploy"
}

variable "ecs_service_name" {
  type        = string
  description = "The name of the ECS service to redeploy when a secret rotation event is detected"
}

variable "ecs_service_arn" {
  type        = string
  description = "The ARN of the ECS service to redeploy when a secret rotation event is detected"
}

variable "lambda_function_tags" {
  type        = map(string)
  description = "Tags to apply to the Lambda function"
  default     = {}
}
