resource "aws_instance" "ec2_proxy" {
  ami           = data.aws_ami.rhel9.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ssh_pubkey.key_name

  iam_instance_profile = aws_iam_instance_profile.ec2_cloudwatch_instance_profile.name

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
  }

  network_interface {
    network_interface_id = aws_network_interface.proxy_eni.id
    device_index         = 0
  }

  user_data = templatefile("${path.module}/user-data/proxy.sh.tftpl", {

  })

  tags = merge(var.default_tags, {
    Name = "ec2-proxy"
  })

  depends_on = [module.vpc_with_nat_instance, aws_instance.ec2_proxy]
}

resource "aws_network_interface" "proxy_eni" {
  subnet_id       = module.vpc_with_nat_instance.private_subnet_id
  security_groups = [aws_security_group.ec2_proxy_sg.id]

  tags = var.default_tags
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
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc_with_nat_instance.vpc_cidr]
    description = "Allow traffic from the VPC CIDR block"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.default_tags
}
