resource "aws_instance" "ec2_ldap" {
  ami           = data.aws_ami.rhel9.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ssh_pubkey.key_name

  iam_instance_profile = aws_iam_instance_profile.ec2_cloudwatch_instance_profile.name

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
  }

  network_interface {
    network_interface_id = aws_network_interface.ldap_eni.id
    device_index         = 0
  }

  user_data = templatefile("${path.module}/user-data/ldap.sh.tftpl", {
    ldap_admin_password = var.ldap_admin_password
  })

  depends_on = [module.vpc_ldap]

  tags = merge(var.default_tags, {
    Name = "ec2-ldap"
  })
}

resource "aws_network_interface" "ldap_eni" {
  subnet_id       = module.vpc_ldap.private_subnet_id
  security_groups = [aws_security_group.ec2_ldap_sg.id]

  tags = var.default_tags
}

resource "aws_security_group" "ec2_ldap_sg" {
  name   = "ec2-ldap-sg"
  vpc_id = module.vpc_ldap.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc_ldap.vpc_cidr]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.clb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.default_tags
}
