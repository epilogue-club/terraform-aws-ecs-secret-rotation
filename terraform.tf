terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.8.0"
    }
  }
  # 1.9.0+ is required for the validation blocks in variables.tf
  required_version = ">= 1.9.0"
}
