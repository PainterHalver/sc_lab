data "aws_ami" "amazon_linux" {
  count       = var.with_nat_instance.enabled ? 1 : 0
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
  count      = var.with_nat_instance.enabled ? 1 : 0
  key_name   = "ssh-pubkey-nat"
  public_key = file(var.with_nat_instance.ssh_pubkey_path)
}

resource "aws_security_group" "sg_nat" {
  count  = var.with_nat_instance.enabled ? 1 : 0
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

  tags = var.default_tags
}

resource "aws_instance" "ec2_nat" {
  count             = var.with_nat_instance.enabled ? 1 : 0
  instance_type     = "t2.micro"
  ami               = data.aws_ami.amazon_linux[0].id
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
