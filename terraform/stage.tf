resource "aws_api_gateway_stage" "dev_stage" {
  client_certificate_id = aws_api_gateway_client_certificate.kafkaRestAPI_client_certificate.id
  deployment_id = aws_api_gateway_deployment.api_gateway_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.kafkaRestAPI.id
  stage_name    = var.api_gateway_stage
  
}

resource "aws_api_gateway_method_settings" "dev_stage_setting" {
  rest_api_id = aws_api_gateway_rest_api.kafkaRestAPI.id
  stage_name  = aws_api_gateway_stage.dev_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.kafkaRestAPI.id
  //stage_name    = var.api_gateway_stage
  //depends_on = ["aws_api_gateway_method.kafakOpsMethodPost", "aws_api_gateway_integration.integration"]
  triggers = {
     redeployment = sha1(jsonencode([
      aws_api_gateway_resource.kafkaOps.id,
      aws_api_gateway_method.kafakOpsMethodPost.id,
      aws_api_gateway_integration.integration.id,
      "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${var.accountId}:function:okta_authorizer_lambda_function/invocations"
    ]))
  }

//"arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${var.accountId}:function:okta_authorizer_lambda_function/invocations"
  /*lifecycle {
    create_before_destroy = true
  }*/
  
}