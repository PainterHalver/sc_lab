resource "aws_instance" "ec2_ldap" {
  ami = data.aws_ami.rhel9.id
  instance_type = var.instance_type
  key_name = aws_key_pair.ssh_pubkey.key_name

  vpc_security_group_ids = [ aws_security_group.ec2_ldap_sg.id ]
  iam_instance_profile = aws_iam_instance_profile.ec2_cloudwatch_instance_profile.name

  root_block_device {
    delete_on_termination = true
    volume_size = 10
  }

  user_data = templatefile("${path.module}/user-data/ldap.sh.tftpl", {
    ldap_admin_password = var.ldap_admin_password
  })

  tags = merge(var.default_tags, {
    Name = "ec2-ldap"
  })
}

resource "aws_security_group" "ec2_ldap_sg" {
  name = "ec2-ldap-sg"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 389
    to_port = 389
    protocol = "tcp"
    security_groups = [aws_security_group.ec2_app_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "ec2_ldap_public_ip" {
  value = aws_instance.ec2_ldap.public_ip
}
