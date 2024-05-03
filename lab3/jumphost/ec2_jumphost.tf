resource "aws_instance" "jumphost" {
  ami                    = data.aws_ami.jumphost.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.jumphost.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.jumphost.id]

  user_data = templatefile("${path.module}/user-data/jumphost.sh.tftpl", {
    efs_dns_name = var.efs_dns_name
  })

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.default_tags, {
    Name = "ec2-jumphost"
  })
}

resource "aws_key_pair" "jumphost" {
  key_name   = "ssh-pubkey-jumphost"
  public_key = file(var.ssh_pubkey_path)

  tags = var.default_tags
}

resource "aws_security_group" "jumphost" {
  name   = "jumphost-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // Should be restricted to an IP range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.default_tags
}
