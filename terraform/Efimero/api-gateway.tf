resource "aws_apigatewayv2_api" "backend_api" {
  name          = "BereBackendAPI"
  protocol_type = "HTTP"
  cors_configuration {
        allow_origins     = ["https://d1l6zgkey4sk0l.cloudfront.net"]
        allow_methods     = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
        allow_headers     = ["Content-Type", "Authorization"]
        expose_headers    = ["*"]
        max_age           = 3600
        allow_credentials = true
    }
  depends_on = [aws_instance.bere_backend]
}

resource "aws_apigatewayv2_integration" "backend_integration" {
  api_id             = aws_apigatewayv2_api.backend_api.id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = "http://${aws_eip_association.eip_assoc.public_ip}:8080/{proxy}"
}

resource "aws_apigatewayv2_route" "cors_options_route" {
  api_id    = aws_apigatewayv2_api.backend_api.id
  route_key = "OPTIONS /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.backend_integration.id}"

  depends_on = [aws_apigatewayv2_integration.backend_integration]
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