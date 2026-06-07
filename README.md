# Terraform ECS Secret Rotation

<p align="center">
  <a href="https://registry.terraform.io/modules/epilogue-club/ecs-secret-rotation/aws/latest">
    <img
      src="https://img.shields.io/badge/View%20on%20Terraform%20Registry-623CE4?style=for-the-badge&logo=terraform&logoColor=white"
      alt="View on Terraform Registry"
    />
  </a>
</p>

**Problem we're solving**: if your ECS service uses an AWS secret that has rotated, you will need to force a new deployment for your app to have the updated secret value.
For example, if your app relies on a RDS (Relational Database Service) secret with the authentication details that rotates, your app won't be able to connect to the database
because it tries to use old credentials.

This simplifies redeploying an ECS service when a secret is rotated.
It's a layer of abstraction over various AWS resources.

What it creates:
- An EventBridge rule to monitor the specific secrets you want to trigger on
- A Lambda function to redeploy the ECS service when a secret rotation event is detected
- CloudWatch logs for the Lambda function
- An IAM role for the Lambda function

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute to this project.

## Basic usage example
```hcl
module "ecs-secret-rotation" {
  source  = "epilogue-club/ecs-secret-rotation/aws"
  version = "1.0.0-alpha.2"

  # these are the required variables
  ecs_cluster_name = "<your ECS cluster name>"
  ecs_region       = "<your AWS region where the ECS cluster is located>"
  ecs_service_arn  = "<your ECS service ARN>"
  ecs_service_name = "<your ECS service name>"
  name_prefix      = "<your name prefix>"
  secrets_to_trigger_on = [
    "<the ARN of the secret you want to trigger on when rotated>",
  ]
}
```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.1.9 |
| <a name="requirement_archive"></a> [archive](#requirement_archive) | >= 2.8.0 |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | >= 6.0 |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_ecs_cluster_name"></a> [ecs_cluster_name](#input_ecs_cluster_name) | The name of the ECS cluster containing the service to redeploy | `string` | n/a | yes |
| <a name="input_ecs_region"></a> [ecs_region](#input_ecs_region) | AWS region where the ECS cluster is located | `string` | n/a | yes |
| <a name="input_ecs_service_arn"></a> [ecs_service_arn](#input_ecs_service_arn) | The ARN of the ECS service to redeploy when a secret rotation event is detected | `string` | n/a | yes |
| <a name="input_ecs_service_name"></a> [ecs_service_name](#input_ecs_service_name) | The name of the ECS service to redeploy when a secret rotation event is detected | `string` | n/a | yes |
| <a name="input_event_rule_tags"></a> [event_rule_tags](#input_event_rule_tags) | Tags to apply to the EventBridge rule | `map(string)` | `{}` | no |
| <a name="input_lambda_function_tags"></a> [lambda_function_tags](#input_lambda_function_tags) | Tags to apply to the Lambda function | `map(string)` | `{}` | no |
| <a name="input_lambda_iam_role_name"></a> [lambda_iam_role_name](#input_lambda_iam_role_name) | What to name the IAM role to be used by the Lambda function | `string` | `"lambda-exec-role"` | no |
| <a name="input_name_prefix"></a> [name_prefix](#input_name_prefix) | Prefix to use for naming AWS resources created by this module | `string` | n/a | yes |
| <a name="input_secrets_to_trigger_on"></a> [secrets_to_trigger_on](#input_secrets_to_trigger_on) | List of secret ARNs that should trigger the redeploy when rotated | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_aws_cloudwatch_log_group_arn"></a> [aws_cloudwatch_log_group_arn](#output_aws_cloudwatch_log_group_arn) | ARN of the CloudWatch Log Group where Lambda function logs are stored |
| <a name="output_event_rule_arn"></a> [event_rule_arn](#output_event_rule_arn) | ARN of the CloudWatch Event Rule that triggers the Lambda function on secret rotation events |
| <a name="output_iam_role_arn"></a> [iam_role_arn](#output_iam_role_arn) | ARN of the IAM role assumed by the Lambda function |
| <a name="output_lambda_function_arn"></a> [lambda_function_arn](#output_lambda_function_arn) | ARN of the Lambda function that will be triggered on secret rotation events |
<!-- END_TF_DOCS -->

## Alternatives

A simpler approach to this module is to have your app directly access the AWS secret(s) it requires. That wasn't suited to our specific use case, hence why we developed this module. However, we recommend considering that approach first.

If you prefer to use CloudFormation, see this [AWS guide](https://aws.amazon.com/blogs/infrastructure-and-automation/restart-amazon-ecs-tasks-with-aws-lambda-and-aws-cloudformation-custom-resources/), which follows a similar approach to this module.
