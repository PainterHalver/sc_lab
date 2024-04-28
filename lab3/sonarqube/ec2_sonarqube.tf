resource "aws_instance" "sonarqube" {
  ami                    = data.aws_ami.centos_9_stream.id
  instance_type          = "t3.small"
  iam_instance_profile   = module.ec2_sonarqube_profle.profile_name
  key_name               = aws_key_pair.sonarqube.key_name
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.sonarqube.id]

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
  }

  user_data = templatefile("${path.module}/user-data/sonarqube.sh.tftpl", {
    efs_dns_name = var.efs_dns_name
  })

  tags = merge(var.default_tags, {
    Name = "ec2-sonarqube"
  })
}

resource "aws_key_pair" "sonarqube" {
  key_name   = "ssh-pubkey-sonarqube"
  public_key = file(var.ssh_pubkey_path)

  tags = var.default_tags
}

resource "aws_security_group" "sonarqube" {
  name   = "sonarqube-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SonarQube web UI
  ingress {
    from_port   = 9000
    to_port     = 9000
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

module "ec2_sonarqube_profle" {
  source = "../../modules/ec2_profile"

  default_tags = var.default_tags

  profile_name     = "EC2SonarQubeProfile"
  role_name        = "EC2SonarQubeRole"
  role_description = "Role for EC2 SonarQube master"

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3FullAccess"]
}
