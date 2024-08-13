# Output the API endpoint
output "api_endpoint" {
  value = "${aws_api_gateway_deployment.dev_deployment.invoke_url}/hello"
}