resource "aws_api_gateway_rest_api" "hello_world_api" {
  name = "hello-world-root-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

#creating a root resource inside rest api
resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.hello_world_api.id
  parent_id   = aws_api_gateway_rest_api.hello_world_api.root_resource_id
  path_part   = "{proxy+}"

}

#method on the proxy root resource
resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.hello_world_api.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "ANY"
  authorization = "NONE"

}

#integrating method with the lambda
resource "aws_api_gateway_integration" "proxy" {
  rest_api_id             = aws_api_gateway_rest_api.hello_world_api.id
  resource_id             = aws_api_gateway_resource.root.id
  http_method             = aws_api_gateway_method.proxy_method.http_method
  integration_http_method = "GET"
  type                    = "AWS PROXY"

  uri = aws_lambda_function.hello_world_lambda.invoke_arn

}

resource "aws_api_gateway_deployment" "dev_deployment" {
  depends_on  = [aws_api_gateway_integration.proxy]

  rest_api_id = aws_api_gateway_rest_api.hello_world_api.id
  stage_name  = "DEV"

}