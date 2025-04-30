resource "aws_ses_template" "bienvenida" {
  name         = "PlantillaBienvenida"
  subject      = "Bienvenido a nuestro servicio"
  text         = "Hola {{name}}, gracias por unirte a nosotros."
  html         = "<h1>Hola {{name}}</h1><p>Gracias por registrarte.</p>"
}
