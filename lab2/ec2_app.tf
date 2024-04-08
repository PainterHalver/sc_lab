resource "aws_instance" "ec2_app" {
  ami             = data.aws_ami.centos_stream_9.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.ssh_pubkey.key_name
  subnet_id       = module.vpc_with_nat_instance.private_subnet_id
  security_groups = [aws_security_group.ec2_app_sg.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_cloudwatch_instance_profile.name

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
  }

  user_data = templatefile("${path.module}/user-data/app.sh.tftpl", {
    sns_topic_arn = aws_sns_topic.ec2_app_stop_alert.arn
    proxy_ip = aws_instance.ec2_proxy.private_ip
  })

  tags = merge(var.default_tags, {
    Name = "ec2-app"
  })

  depends_on = [module.vpc_with_nat_instance, aws_instance.ec2_proxy]
}

resource "aws_security_group" "ec2_app_sg" {
  name   = "ec2-app-sg"
  vpc_id = module.vpc_with_nat_instance.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.default_tags
}
