terraform {
  required_version = ">= 1.12.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Variables here rely on OpenTofu early evaluation; the env tfvars file must
  # be passed to `tofu init` (the tofu-init action does this).
  backend "s3" {
    bucket       = var.backend_bucket
    key          = var.backend_key
    region       = var.aws_region
    encrypt      = true
    use_lockfile = true
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
