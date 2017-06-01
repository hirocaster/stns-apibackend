resource "aws_api_gateway_rest_api" "user" {
  name = "${var.role}-stnsserver"
  description = "stns server"
}

resource "aws_api_gateway_api_key" "user" {
  name = "${aws_api_gateway_rest_api.user.name}"

  stage_key {
    rest_api_id = "${aws_api_gateway_rest_api.user.id}"
    stage_name = "${aws_api_gateway_deployment.user.stage_name}"
  }
}

resource "aws_api_gateway_usage_plan" "stns" {
  name         = "stns"
  description  = "for stns-apibackend"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.user.id}"
    stage  = "${aws_api_gateway_deployment.user.stage_name}"
  }
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = "${aws_api_gateway_api_key.user.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.stns.id}"
  depends_on = ["aws_api_gateway_usage_plan.stns", "aws_api_gateway_api_key.user"]
}

resource "aws_api_gateway_deployment" "user" {
  rest_api_id = "${aws_api_gateway_rest_api.user.id}"
  stage_name = "prod"

  depends_on = ["aws_api_gateway_method.user_name","aws_api_gateway_method.group_name"]
}

resource "aws_api_gateway_resource" "user" {
  rest_api_id = "${aws_api_gateway_rest_api.user.id}"
  parent_id = "${aws_api_gateway_rest_api.user.root_resource_id}"
  path_part = "user"
}

resource "aws_api_gateway_domain_name" "stns" {
  domain_name = "${var.domain_name}"
  certificate_arn = "${var.certificate_arn}"
}

resource "aws_route53_record" "stns" {
  zone_id = "${var.zone_id}"

  name = "${aws_api_gateway_domain_name.stns.domain_name}"
  type = "A"

  alias {
    name                   = "${aws_api_gateway_domain_name.stns.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.stns.cloudfront_zone_id}"
    evaluate_target_health = true
  }

  depends_on = ["aws_api_gateway_integration_response.group_list",
    "aws_api_gateway_integration_response.user_name",
    "aws_api_gateway_integration_response.group_id",
    "aws_api_gateway_integration_response.group_name",
    "aws_api_gateway_integration_response.user_list",
    "aws_api_gateway_deployment.user",
    "aws_api_gateway_integration_response.user_id"
  ]
}

resource "aws_api_gateway_base_path_mapping" "stns" {
  api_id      = "${aws_api_gateway_rest_api.user.id}"
  stage_name  = "${aws_api_gateway_deployment.user.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.stns.domain_name}"
}
