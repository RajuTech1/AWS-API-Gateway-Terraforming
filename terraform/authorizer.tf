
resource "aws_api_gateway_authorizer" "kafkaRestAPI" {
  name                   = "okta_authorizer_lambda_function"
  rest_api_id            = aws_api_gateway_rest_api.kafkaRestAPI.id
  authorizer_uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${var.accountId}:function:okta_authorizer_lambda_function/invocations"  
  
  authorizer_credentials = aws_iam_role.invocation_role.arn
}

resource "aws_iam_role" "invocation_role" {
  name = "api_gateway_auth_invocation"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "invocation_policy" {
  name = "default"
  role = aws_iam_role.invocation_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "arn:aws:lambda:us-east-2:${var.accountId}:function:okta_authorizer_lambda_function"
    }
  ]
}
EOF
}

  //"Resource": "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${accountId}:function:okta_authorizer_lambda_function/invocations"  
  

resource "aws_iam_role" "okta_authorizer_lambda_function_role" {
  name = "okta_authorizer_lambda_function_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

/*
resource "aws_lambda_function" "authorizer" {
  filename      = "lambda-function.zip"
  function_name = "api_gateway_authorizer"
  role          = aws_iam_role.invocation_role.arn
  handler       = "lambda-auth.js"
  
  runtime = "nodejs12.x"
  
  source_code_hash = filebase64sha256("lambda-authorizer.zip")
}*/