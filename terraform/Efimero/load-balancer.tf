resource "aws_security_group" "sg-lb" {
    name = "sg_lb"
    description = "Grupo de seguridad para el load balancer"
    vpc_id = local.vpc_id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
        description = "Allow HTTP traffic from VPC CIDR"
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
  name="main-lb"
  subnets = [local.subnet_2a,local.subnet_2b]
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.sg-lb.id]
  enable_deletion_protection = true
}

resource "aws_lb_target_group" "ec2_a" {
  name     = "tg-ec2-a"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${local.vpc_id}"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "ec2_b" {
  name     = "tg-ec2-b"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${local.vpc_id}"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_target_group_attachment" "a1" {
  target_group_arn = aws_lb_target_group.ec2_a.arn
  target_id        = aws_instance.bere_backend.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "b1" {
  target_group_arn = aws_lb_target_group.ec2_b.arn
  target_id        = aws_instance.bere_backend_2.id
  port             = 80
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