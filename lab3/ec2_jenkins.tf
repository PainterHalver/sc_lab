resource "aws_instance" "ec2_jenkins" {
  ami           = data.aws_ami.rhel9.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ssh_pubkey.key_name

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
  }

  user_data = templatefile("${path.module}/user-data/jenkins.sh.tftpl", {

  })

  tags = merge(var.default_tags, {
    Name = "jenkins"
  })
}

resource "aws_network_interface" "app_eni" {
  subnet_id       = module.vpc.public_subnet_id
  security_groups = [aws_security_group.jenkins_sg.id]

  tags = var.default_tags
}

resource "aws_security_group" "jenkins_sg" {
  name   = "jenkins-sg"
  vpc_id = module.vpc.vpc_id

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
