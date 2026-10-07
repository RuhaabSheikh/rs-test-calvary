terraform {
  required_version = ">= 1.12.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Partial configuration: the rest comes from
  # environments/config.<environment>.tfbackend, passed to `tofu init` with
  # -backend-config (the tofu-init action does this).
  backend "s3" {
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Repository  = "rs-test-calvary"
      ManagedBy   = "opentofu"
    }
  }
}
