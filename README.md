# Terraform ECS Secret Rotation

<p align="center">
  <a href="https://registry.terraform.io/modules/epilogue-club/ecs-secret-rotation/aws/latest">
    <img
      src="https://img.shields.io/badge/View%20on%20Terraform%20Registry-623CE4?style=for-the-badge&logo=terraform&logoColor=white"
      alt="View on Terraform Registry"
    />
  </a>
</p>



This simplifies redeploying an ECS service when a secret is rotated.
It's a layer of abstraction over various AWS resources.

What it creates:
- An EventBridge rule to monitor the specific secrets you want to trigger on
- A Lambda function to redeploy the ECS service when a secret rotation event is detected
- An IAM role for the Lambda function

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute to this project.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.9 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | >= 2.8.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.8.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.46.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_cloudwatch_event_rule.secret_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.lambda_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_policy.lambda_exec_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_exec_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.lambda_basic_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_exec_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.ecs_redeploy_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.execute_lambda_from_eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [archive_file.lambda_src_code](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.lambda_exec_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_exec_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | The name of the ECS cluster containing the service to redeploy | `string` | n/a | yes |
| <a name="input_ecs_region"></a> [ecs\_region](#input\_ecs\_region) | AWS region where the ECS cluster is located | `string` | n/a | yes |
| <a name="input_ecs_service_arn"></a> [ecs\_service\_arn](#input\_ecs\_service\_arn) | The ARN of the ECS service to redeploy when a secret rotation event is detected | `string` | n/a | yes |
| <a name="input_ecs_service_name"></a> [ecs\_service\_name](#input\_ecs\_service\_name) | The name of the ECS service to redeploy when a secret rotation event is detected | `string` | n/a | yes |
| <a name="input_event_rule_tags"></a> [event\_rule\_tags](#input\_event\_rule\_tags) | Tags to apply to the EventBridge rule | `map(string)` | `{}` | no |
| <a name="input_lambda_function_tags"></a> [lambda\_function\_tags](#input\_lambda\_function\_tags) | Tags to apply to the Lambda function | `map(string)` | `{}` | no |
| <a name="input_lambda_iam_role_name"></a> [lambda\_iam\_role\_name](#input\_lambda\_iam\_role\_name) | What to name the IAM role to be used by the Lambda function | `string` | `"lambda-exec-role"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix to use for naming AWS resources created by this module | `string` | n/a | yes |
| <a name="input_secrets_to_trigger_on"></a> [secrets\_to\_trigger\_on](#input\_secrets\_to\_trigger\_on) | List of secret ARNs that should trigger the redeploy when rotated | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_event_rule_arn"></a> [event\_rule\_arn](#output\_event\_rule\_arn) | ARN of the CloudWatch Event Rule that triggers the Lambda function on secret rotation events |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of the IAM role assumed by the Lambda function |
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | ARN of the Lambda function that will be triggered on secret rotation events |
<!-- END_TF_DOCS -->
