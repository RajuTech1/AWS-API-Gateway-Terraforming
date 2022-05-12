/*resource "aws_api_gateway_domain_name" "kafkaRestAPI" {
  domain_name              = aws_acm_certificate.kafkaRestAPI.domain_name
  private_certificate_arn = aws_acm_certificate.kafkaRestAPI.arn

  endpoint_configuration {
    types = ["PRIVATE"]
  }
}

resource "aws_api_gateway_base_path_mapping" "kafkaRestAPI" {
  api_id      = aws_api_gateway_rest_api.kafkaRestAPI.id
  domain_name = aws_api_gateway_domain_name.kafkaRestAPI.domain_name
  stage_name  = aws_api_gateway_stage.kafkaRestAPI.stage_name
}
*/