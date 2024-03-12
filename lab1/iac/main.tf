resource "aws_instance" "ec2_app" {
  ami = data.aws_ami.rhel9.id
  instance_type = var.instance_type
  key_name = aws_key_pair.ssh_pubkey.key_name

  vpc_security_group_ids = [ aws_security_group.ec2_app_sg.id ]

  tags = var.default_tags
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
