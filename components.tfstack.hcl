required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.7.0"
  }

  archive = {
    source  = "hashicorp/archive"
    version = "~> 2.4.0"
  }

  local = {
    source = "hashicorp/local"
    version = "~> 2.4.0"
  }
}

provider "aws" "this" {
  config {
    region = var.region

    assume_role_with_web_identity {
      role_arn                = var.role_arn
      web_identity_token_file = var.identity_token_file
    }

    default_tags {
      tags = var.default_tags
    }
  }
}

provider "archive" "this" {}
provider "local" "this" {}


component "s3" {
  for_each = toset(var.instances)
  source = "./s3"

  inputs = {
    bucket_prefix = each.value
  }

  providers = {
    aws    = provider.aws.this
  }
}

component "lambda" {
  for_each = toset(var.instances)
  source = "./lambda"

  inputs = {
    bucket_id     = component.s3.bucket_id
    function_name = each.value
  }

  providers = {
    aws     = provider.aws.this
    archive = provider.archive.this
    local   = provider.local.this
  }
}

component "api_gateway" {
  for_each = toset(var.instances)
  source = "./api-gateway"

  inputs = {
    gateway_name         = each.value
    lambda_function_name = component.lambda.function_name
    lambda_invoke_arn    = component.lambda.invoke_arn
  }

  providers = {
    aws    = provider.aws.this
  }
}
