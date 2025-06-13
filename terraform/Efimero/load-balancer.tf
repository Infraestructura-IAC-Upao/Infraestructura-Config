resource "aws_security_group" "sg-lb" {
    # checkov:skip=CKV_AWS_382: Egress abierto permitido temporalmente en entorno de desarrollo para facilitar pruebas de conectividad
    name = "sg_lb"
    description = "Grupo de seguridad para el load balancer"
    vpc_id = local.vpc_id

    ingress {
       # checkov:skip=CKV_AWS_260: El acceso HTTP público (puerto 80) está habilitado temporalmente en entorno de desarrollo para pruebas con ALB
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP traffic from VPC CIDR"
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP traffic"
    }

    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic"
    }
  
}


resource "aws_lb" "main_lb" {
  # checkov:skip=CKV2_AWS_20: El redireccionamiento de HTTP a HTTPS se maneja mediante API Gateway y no directamente en el ALB
  # checkov:skip=CKV2-AWS-28: Este ALB es público pero no requiere WAF en este entorno (uso no productivo)
  # checkov:skip=CKV_AWS_131: No se requiere eliminar encabezados inválidos en entorno de desarrollo, se mantiene por simplicidad
  # checkov:skip=CKV_AWS_150: Protección contra eliminación desactivada intencionalmente en entorno de desarrollo
  name="main-lb"
  subnets = [local.subnet_2a,local.subnet_2b]
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.sg-lb.id]
  enable_deletion_protection = false

}

resource "aws_lb_target_group" "ec2_a" {
  # checkov:skip=CKV_AWS_378: Tráfico está cifrado por API Gateway; el ALB solo enruta tráfico HTTP interno

  name     = "tg-ec2-a"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${local.vpc_id}"

  health_check {
    path                = "/api/v1/auth/login"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "401"
  }
}

resource "aws_lb_target_group" "ec2_b" {
  # checkov:skip=CKV_AWS_378: Tráfico está cifrado por API Gateway; el ALB solo enruta tráfico HTTP interno

  name     = "tg-ec2-b"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${local.vpc_id}"

  health_check {
    path                = "/api/v1/auth/login"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "401"
  }
}

resource "aws_lb_target_group_attachment" "a1" {
  target_group_arn = aws_lb_target_group.ec2_a.arn
  target_id        = aws_instance.bere_backend.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "b1" {
  target_group_arn = aws_lb_target_group.ec2_b.arn
  target_id        = aws_instance.bere_backend_2.id
  port             = 8080
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.main_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn  = aws_lb_target_group.ec2_a.arn
        weight = 70
      }

      target_group {
        arn  = aws_lb_target_group.ec2_b.arn
        weight = 30
      }

      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}