data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  // Get the free tier Amazon Linux AMI
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_key_pair" "ssh_pubkey_nat" {
  key_name   = "ssh-pubkey-nat"
  public_key = file(var.ssh_pubkey_path)
}

resource "aws_security_group" "sg_nat" {
  name   = "ec2-nat-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// This should be the Private IP, the public IP should be assigned by subnet
resource "aws_network_interface" "eni_nat" {
  subnet_id         = aws_subnet.public_subnet.id
  security_groups   = [aws_security_group.sg_nat.id]
  source_dest_check = false
}

resource "aws_instance" "ec2_nat" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.amazon_linux.id
  key_name      = aws_key_pair.ssh_pubkey_nat.key_name

  user_data = file("${path.module}/user-data/nat.sh")

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
  }

  network_interface {
    network_interface_id = aws_network_interface.eni_nat.id
    device_index         = 0
  }

  tags = merge(var.default_tags, {
    Name = "ec2-nat-instance"
  })
}
