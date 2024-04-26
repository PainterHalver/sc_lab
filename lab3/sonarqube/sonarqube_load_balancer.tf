resource "aws_lb" "sonarqube" {
  name               = "sonarqube-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [var.public_subnet_id, var.other_public_subnet_id]
  security_groups    = [aws_security_group.alb.id]

  # enable_deletion_protection = true

  tags = var.default_tags
}

resource "aws_security_group" "alb" {
  name   = "sonarqube-alb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.default_tags
}

// HTTP LISTENER
resource "aws_lb_listener" "sonarqube" {
  load_balancer_arn = aws_lb.sonarqube.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_sonarqube_http.arn
  }

  tags = var.default_tags
}

resource "aws_lb_target_group" "ec2_sonarqube_http" {
  name     = "ec2-sonarqube-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "9000"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 10
    interval            = 20
  }

  tags = var.default_tags
}

resource "aws_lb_target_group_attachment" "sonarqube" {
  target_group_arn = aws_lb_target_group.ec2_sonarqube_http.arn
  target_id        = aws_instance.sonarqube.id
  port             = 9000
}
