####### Classic Load Balancer: Free tier
resource "aws_elb" "ldap_clb" {
  name            = "ldap-clb"
  subnets         = [module.vpc_ldap.public_subnet_id]
  security_groups = [aws_security_group.clb_sg.id]
  internal        = false

  listener {
    instance_port     = 389
    instance_protocol = "tcp"
    lb_port           = 389
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:389"
    interval            = 30
  }

  instances                 = [aws_instance.ec2_ldap.id]
  cross_zone_load_balancing = true // default
  idle_timeout              = 60   // default
}

// TODO: Resrtict the source IP
resource "aws_security_group" "clb_sg" {
  name   = "ldap-clb-sg"
  vpc_id = module.vpc_ldap.vpc_id

  ingress {
    from_port   = 389
    to_port     = 389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

####### Network Load Balancer: Cost money, but better performance

/**

resource "aws_lb" "ldap_nlb" {
  name               = "ldap-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [module.vpc_ldap.public_subnet_id]
  security_groups    = [aws_security_group.nlb_sg.id]

  # enable_deletion_protection = true
}

// TODO: Resrtict the source IP
resource "aws_security_group" "nlb_sg" {
  name   = "ldap-nlb-sg"
  vpc_id = module.vpc_ldap.vpc_id

  ingress {
    from_port   = 389
    to_port     = 389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

####################################################### LDAP
resource "aws_lb_listener" "ldap_nlb_listener" {
  load_balancer_arn = aws_lb.ldap_nlb.arn
  port              = 389
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_ldap_target_group.arn
  }
}

resource "aws_lb_target_group" "ec2_ldap_target_group" {
  name     = "ec2-ldap-tg"
  port     = 389
  protocol = "TCP"
  vpc_id   = module.vpc_ldap.vpc_id
}

resource "aws_lb_target_group_attachment" "ec2_ldap_tg_attachment" {
  target_group_arn = aws_lb_target_group.ec2_ldap_target_group.arn
  target_id        = aws_instance.ec2_ldap.id
  port             = 389
}

####################################################### HTTP
resource "aws_lb_listener" "http_nlb_listener" {
  load_balancer_arn = aws_lb.ldap_nlb.arn
  port              = 80
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_ldap_http_target_group.arn
  }
}

resource "aws_lb_target_group" "ec2_ldap_http_target_group" {
  name     = "ec2-ldap-http-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = module.vpc_ldap.vpc_id
}

resource "aws_lb_target_group_attachment" "ec2_ldap_http_tg_attachment" {
  target_group_arn = aws_lb_target_group.ec2_ldap_http_target_group.arn
  target_id        = aws_instance.ec2_ldap.id
  port             = 80
}

**/
