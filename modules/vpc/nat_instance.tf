data "aws_ami" "centos_stream_9" {
  count       = var.with_nat_instance.enabled ? 1 : 0
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["CentOS-Stream-ec2-9-*"]
  }
}

resource "aws_key_pair" "ssh_pubkey_nat" {
  count      = var.with_nat_instance.enabled ? 1 : 0
  key_name   = "ssh-pubkey-nat"
  public_key = file(var.with_nat_instance.ssh_pubkey_path)
}

# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html#NATSG
resource "aws_security_group" "sg_nat" {
  count  = var.with_nat_instance.enabled ? 1 : 0
  name   = "ec2-nat-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Should be Public IP address range of your network
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.default_tags
}

resource "aws_instance" "ec2_nat" {
  count             = var.with_nat_instance.enabled ? 1 : 0
  instance_type     = "t2.micro"
  ami               = data.aws_ami.centos_stream_9[0].id
  key_name          = aws_key_pair.ssh_pubkey_nat[0].key_name
  subnet_id         = aws_subnet.public_subnet.id
  security_groups   = [aws_security_group.sg_nat[0].id]
  source_dest_check = false

  user_data = file("${path.module}/user-data/nat.sh")

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
  }

  tags = merge(var.default_tags, {
    Name = "ec2-nat-instance"
  })
}
