resource "aws_lb" "app" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [module.vpc_with_nat_instance.public_subnet_id, aws_subnet.public_2.id]
  security_groups    = [aws_security_group.alb.id]

  # enable_deletion_protection = true

  tags = var.default_tags
}

resource "aws_security_group" "alb" {
  name   = "app-alb-sg"
  vpc_id = module.vpc_with_nat_instance.vpc_id

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
resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_app_http.arn
  }

  tags = var.default_tags
}

resource "aws_lb_target_group" "ec2_app_http" {
  name                 = "ec2-app-http-tg"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = module.vpc_with_nat_instance.vpc_id
  deregistration_delay = 30

  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
    path                = "/health"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 3
  }

  tags = var.default_tags
}
