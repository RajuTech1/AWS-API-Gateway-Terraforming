
resource "tls_private_key" "kafkaRestAPI" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "kafkaRestAPI" {
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
  dns_names             = [var.rest_api_domain_name]
  key_algorithm         = tls_private_key.kafkaRestAPI.algorithm
  private_key_pem       = tls_private_key.kafkaRestAPI.private_key_pem
  validity_period_hours = 12

  subject {
    common_name  = var.rest_api_domain_name
    organization = "ORG - kafkaRestAPI"
  }
}

resource "aws_acm_certificate" "kafkaRestAPI" {
  certificate_body = tls_self_signed_cert.kafkaRestAPI.cert_pem
  private_key      = tls_private_key.kafkaRestAPI.private_key_pem
}

resource "aws_api_gateway_client_certificate" "kafkaRestAPI_client_certificate" {
  description = "kafkaRestAPI certificate"
}