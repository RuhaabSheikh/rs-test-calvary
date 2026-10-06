variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-southeast-2"
}

variable "environment" {
  description = "Target environment (test or prod)"
  type        = string
}

variable "backend_bucket" {
  description = "S3 bucket holding the OpenTofu state for this environment"
  type        = string
}

variable "backend_key" {
  description = "Object key of the state file within the backend bucket"
  type        = string
}
