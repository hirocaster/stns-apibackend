resource "aws_api_gateway_resource" "user_id" {
  rest_api_id = "${aws_api_gateway_rest_api.user.id}"
  parent_id = "${aws_api_gateway_resource.user.id}"
  path_part = "id"
}
