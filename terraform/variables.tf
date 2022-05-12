variable "aws_region" {
  default     = "us-east-1"
  description = "AWS Region to deploy example API Gateway REST API"
  type        = string
}

variable "accountId" {
  default     = "249683359991"
  description = "AWS accountId to deploy example API Gateway REST API"
  type        = string
}

variable "vpc_id" {
  default     = "vpc-0e951e73"
  description = "vpc_id"
  type        = string
}

variable "api_gateway_stage" {
  default     = "dev-stage"
  description = "AWS Region to deploy example API Gateway REST API"
  type        = string
}

variable "rest_api_domain_name" {
  default     = "aws.amazon.com"
  description = "Domain name of the API Gateway REST API for self-signed TLS certificate"
  type        = string
}

variable "rest_api_name" {
  default     = "kafkaAPI"
  description = "Name of the API Gateway REST API (can be used to trigger redeployments)"
  type        = string
}

variable "rest_api_path" {
  default     = "/apis"
  description = "Path to create in the API Gateway REST API (can be used to trigger redeployments)"
  type        = string
}