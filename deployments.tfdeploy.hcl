identity_token "aws" {
  audience = ["aws.workload.identity"]
}

deployment "production" {
  variables = {
    role_arn            = "arn:aws:iam::891350601298:role/local-dev-aws-project-admin"
    identity_token_file = identity_token.aws.jwt_filename
    instances           = ["daniels-aws-stack-demo"]
    # instances = [] # disabled
  }
}
