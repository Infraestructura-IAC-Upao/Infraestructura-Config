resource "aws_apigatewayv2_api" "backend_api" {
  name          = "BereBackendAPI"
  protocol_type = "HTTP"

  depends_on = [aws_instance.bere_backend]
}

resource "aws_apigatewayv2_integration" "backend_integration" {
  api_id             = aws_apigatewayv2_api.backend_api.id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = "http://${aws_eip_association.eip_assoc.public_ip}:8080"

  depends_on = [aws_eip_association.eip_assoc]
}

resource "aws_apigatewayv2_route" "backend_route" {
  api_id    = aws_apigatewayv2_api.backend_api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.backend_integration.id}"

  depends_on = [aws_apigatewayv2_integration.backend_integration]
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.backend_api.id
  name        = "$default"
  auto_deploy = true

  depends_on = [aws_apigatewayv2_route.backend_route]
}