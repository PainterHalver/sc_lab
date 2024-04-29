data "cloudinit_config" "nat_user_data" {
  base64_encode = true

  part {
    filename     = "nat.sh"
    content_type = "text/x-shellscript"
    content      = file("${path.module}/user-data/nat.sh")
  }

  part {
    filename     = "nat_metrics.sh"
    content_type = "text/x-shellscript"
    content      = var.with_nat_instance.export_cloudwatch_metrics ? file("${path.module}/user-data/nat_metrics.sh") : ""
  }
}

data "aws_ami" "centos_stream_9" {
  count       = var.with_nat_instance.enabled ? 1 : 0
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["CentOS-Stream-ec2-9-*"]
  }
}

resource "aws_key_pair" "nat" {
  count      = var.with_nat_instance.enabled ? 1 : 0
  key_name   = "ssh-pubkey-nat"
  public_key = file(var.with_nat_instance.ssh_pubkey_path)
}

# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html#NATSG
resource "aws_security_group" "nat" {
  count  = var.with_nat_instance.enabled ? 1 : 0
  name   = "ec2-nat-sg"
  vpc_id = aws_vpc.this.id

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

  // Alow ICMP from the private subnet, for `ping`
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.private_subnet_cidr]
  }

  // UDP For traceroute
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = [var.private_subnet_cidr]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

  // ICMP for ping
  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // UDP for traceroute
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.default_tags
}

resource "aws_instance" "nat" {
  count                = var.with_nat_instance.enabled ? 1 : 0
  instance_type        = "t2.micro"
  ami                  = data.aws_ami.centos_stream_9[0].id
  key_name             = aws_key_pair.nat[0].key_name
  subnet_id            = aws_subnet.public.id
  vpc_security_group_ids = [ aws_security_group.nat[0].id ]
  source_dest_check    = false
  iam_instance_profile = var.with_nat_instance.instance_profile_name

  user_data = data.cloudinit_config.nat_user_data.rendered

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
  }

  tags = merge(var.default_tags, {
    Name = "ec2-nat-instance"
  })
}
