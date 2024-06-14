# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "instances" {
  type    = set(string)
  default = ["daniels-aws-stack-demo"]
}

variable "region" {
  type = string
  default = "eu-central-1"
}

variable "identity_token_file" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "default_tags" {
  description = "A map of default tags to apply to all AWS resources"
  type        = map(string)
  default     = {
    project = "DanielMSchmidt/aws-stack"
  }
}
