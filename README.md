# Terraform ECS Secret Rotation Redeploy

This simplifies redeploying an ECS service when a secret is rotated.
It's a layer of abstraction over various AWS resources.

What it creates:
- An EventBridge rule to monitor the specific secrets you want to trigger on
- A Lambda function to redeploy the ECS service when a secret rotation event is detected
- An IAM role for the Lambda function

## Contributing

Prerequisites for setting up your development environment:
1. [precommit](https://pre-commit.com/) installed
1. Install [TFLint](https://github.com/terraform-linters/tflint)
1. run `precommit install` to install the git hooks

Create a branch of the `main` branch and make your changes. Try to keep your PR small, with one change per PR if possible.
