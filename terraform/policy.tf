data "aws_iam_policy_document" "resource-policy" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "execute-api:Invoke",
    ]
    resources = [
      "execute-api:/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpc"
      values   = ["${var.vpc_id}"]
    }
  }
}

/*resource "aws_api_gateway_rest_api_policy" "kafkaRestAPI_policy" {
  rest_api_id = aws_api_gateway_rest_api.kafkaRestAPI.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "execute-api:Invoke",
      "Resource": "${aws_api_gateway_rest_api.kafkaRestAPI.execution_arn}"//"arn:aws:execute-api"    
    }
  ]
}
EOF
}*/