locals {
  function_source = "../lambda-authorizer.zip"
}

resource "aws_s3_bucket" "kafkaoktabucket" {
  bucket = "kafkaoktabucket"
  acl    = "private"
  versioning {
    enabled = true
  }  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.kafkaoktabucket.id

  target_bucket = aws_s3_bucket.kafkaoktabucket.id
  target_prefix = "log/"
}

resource "aws_s3_object" "okta_authorizer_lambda_function" {
  bucket = aws_s3_bucket.kafkaoktabucket.id
  key    = "${filemd5(local.function_source)}.zip"
  source = local.function_source
}

module "lambda_function_existing_package_s3"{
  source = "terraform-aws-modules/lambda/aws"

  function_name = "okta_authorizer_lambda_function"
  description   = "Kafka lambda function"
  handler       = "index.lambda_handler"
  runtime       = "nodejs12.x"

  create_package      = false
  s3_existing_package = {
    bucket = aws_s3_bucket.kafkaoktabucket.id
    key    = aws_s3_object.okta_authorizer_lambda_function.id
  }
  publish = true
  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "arn:aws:execute-api:${var.aws_region}:${var.accountId}:${aws_api_gateway_rest_api.kafkaRestAPI.id}/*/${aws_api_gateway_method.kafakOpsMethodPost.http_method}${aws_api_gateway_resource.kafkaOps.path}"
      //  source_arn = "arn:aws:execute-api:${var.aws_region}:*:${aws_api_gateway_rest_api.kafkaRestAPI.id}/*/${aws_api_gateway_method.kafakOpsMethodPost.http_method}${aws_api_gateway_resource.kafkaOps.path}"
    }
  }
}