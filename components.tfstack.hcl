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
