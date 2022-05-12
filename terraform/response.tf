resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.kafkaRestAPI.id
  resource_id = aws_api_gateway_resource.kafkaOps.id
  http_method = aws_api_gateway_method.kafakOpsMethodPost.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "MyKafkaIntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.kafkaRestAPI.id
  resource_id = aws_api_gateway_resource.kafkaOps.id
  http_method = aws_api_gateway_method.kafakOpsMethodPost.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  # Transforms the backend JSON response to XML
  response_templates = {
    "application/xml" = <<EOF
        #set($inputRoot = $input.path('$'))
        <?xml version="1.0" encoding="UTF-8"?>
        <message>
            $inputRoot.body
        </message>
        EOF
        }
}

