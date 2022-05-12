resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.kafkaRestAPI.id
  resource_id             = aws_api_gateway_resource.kafkaOps.id
  http_method             = aws_api_gateway_method.kafakOpsMethodPost.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
   uri = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:${var.accountId}:function:backendLambda/invocations"  
   //uri = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:*:function:backendLambda/invocations"  
 
   //uri = "arn:aws:lambda:us-east-1:249683359991:function:backendLambda/invocations"
  //uri = "https://lambda.us-east-1.amazonaws.com/2015-03-31/functions/arn:aws:lambda:us-east-1:249683359991:function:backendLambda/invocations"
    //"AWS_PROXY"
  //uri                     = aws_lambda_function.lambda.invoke_arn #change
  //uri = "arn:aws:lambda:us-east-1:511182126229:function:investment-index-service-put-records-api-dev"
 
}