component "s3" {
  source = "./s3"

  inputs = {
    bucket_prefix = "daniels-aws-stack-demo"
  }

  providers = {
    aws    = provider.aws.this
  }
}

component "lambda" {
  source = "./lambda"

  inputs = {
    bucket_id     = component.s3.bucket_id
    function_name = "daniels-aws-stack-demo"
  }

  providers = {
    aws     = provider.aws.this
    archive = provider.archive.this
    local   = provider.local.this
  }
}

component "api_gateway" {
  source = "./api-gateway"

  inputs = {
    gateway_name         = "daniels-aws-stack-demo"
    lambda_function_name = component.lambda.function_name
    lambda_invoke_arn    = component.lambda.invoke_arn
  }

  providers = {
    aws    = provider.aws.this
  }
}
