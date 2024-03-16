resource "aws_instance" "ec2_app" {
  ami = data.aws_ami.rhel9.id
  instance_type = var.instance_type
  key_name = aws_key_pair.ssh_pubkey.key_name

  vpc_security_group_ids = [ aws_security_group.ec2_app_sg.id ]

  root_block_device {
    delete_on_termination = true
    volume_size = 10
  }

  user_data = templatefile("${path.module}/user-data/app.sh.tftpl", {
    ldap_domain = aws_instance.ec2_ldap.private_dns
    ldap_admin_password = var.ldap_admin_password
  })

  tags = merge(var.default_tags, {
    Name = "ec2-app"
  })

  # depends_on = [ aws_instance.ec2_ldap ]
}

resource "aws_key_pair" "ssh_pubkey" {
  key_name = "ssh-pubkey"
  public_key = file(var.ssh_pubkey_path)
}

resource "aws_security_group" "ec2_app_sg" {
  name = "ec2-app-sg"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "ec2_app_public_ip" {
  value = aws_instance.ec2_app.public_ip
}
