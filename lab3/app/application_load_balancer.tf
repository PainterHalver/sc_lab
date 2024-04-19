resource "aws_lb" "app_alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [module.vpc_with_nat_instance.public_subnet_id, aws_subnet.public_subnet_2.id]
  security_groups    = [aws_security_group.alb_sg.id]

  # enable_deletion_protection = true
}

resource "aws_security_group" "alb_sg" {
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
}

// HTTP LISTENER
resource "aws_lb_listener" "http_alb_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_app_http_target_group.arn
  }
}

resource "aws_lb_target_group" "ec2_app_http_target_group" {
  name     = "ec2-app-http-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc_with_nat_instance.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}
