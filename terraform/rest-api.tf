/*resource "aws_api_gateway_rest_api" "kafkaRestAPI" {
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = var.rest_api_name
      version = "1.0"
    }
    paths = {
      (var.rest_api_path) = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           ="POST"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
          }
        }
      }
    }
  })

  name = var.rest_api_name

  endpoint_configuration {
    types = ["PRIVATE"]
  }
}*/

resource "aws_api_gateway_rest_api" "kafkaRestAPI" {
  name        = "kafkaRestAPI"
  description = "Kafka API"
  endpoint_configuration {
    types = ["PRIVATE"]
  }

  policy = "${data.aws_iam_policy_document.resource-policy.json}"
}

resource "aws_api_gateway_resource" "kafkaOps" {
  rest_api_id = aws_api_gateway_rest_api.kafkaRestAPI.id
  parent_id   = aws_api_gateway_rest_api.kafkaRestAPI.root_resource_id
  path_part   = "kafkaOps"
}

resource "aws_api_gateway_method" "kafakOpsMethodPost" {
  rest_api_id   = aws_api_gateway_rest_api.kafkaRestAPI.id
  resource_id   = aws_api_gateway_resource.kafkaOps.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "backendLambda"
  //function_name = "investment-index-service-put-records-api-dev" #change
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.accountId}:${aws_api_gateway_rest_api.kafkaRestAPI.id}/*/${aws_api_gateway_method.kafakOpsMethodPost.http_method}${aws_api_gateway_resource.kafkaOps.path}"
  
}