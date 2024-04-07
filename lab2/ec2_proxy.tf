resource "aws_instance" "ec2_proxy" {
  ami             = data.aws_ami.centos_stream_9.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.ssh_pubkey.key_name
  subnet_id       = module.vpc_with_nat_instance.private_subnet_id
  security_groups = [aws_security_group.ec2_proxy_sg.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_cloudwatch_instance_profile.name

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
  }

  user_data = templatefile("${path.module}/user-data/proxy.sh.tftpl", {

  })

  tags = merge(var.default_tags, {
    Name = "ec2-proxy"
  })

  depends_on = [module.vpc_with_nat_instance, aws_instance.ec2_proxy]
}

resource "aws_security_group" "ec2_proxy_sg" {
  name   = "ec2-proxy-sg"
  vpc_id = module.vpc_with_nat_instance.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 3128
    to_port         = 3128
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_app_sg.id]
    description     = "Allow proxy traffic from the application only"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.default_tags
}
