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
