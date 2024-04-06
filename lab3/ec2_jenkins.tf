resource "aws_instance" "ec2_jenkins" {
  ami                  = data.aws_ami.centos_stream_9.id
  instance_type        = var.instance_type
  key_name             = aws_key_pair.ssh_pubkey.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_jenkins_instance_profile.name

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
  }

  network_interface {
    network_interface_id = aws_network_interface.jenkins_eni.id
    device_index         = 0
  }

  user_data = templatefile("${path.module}/user-data/jenkins.sh", {

  })

  tags = merge(var.default_tags, {
    Name = "jenkins"
  })
}

resource "aws_network_interface" "jenkins_eni" {
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

  # Jenkins web UI
  ingress {
    from_port   = 8080
    to_port     = 8080
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

# Roles for jenkins to use Packer
resource "aws_iam_role" "ec2_jenkins_role" {
  name        = "JenkinsPackerRole"
  description = "Role for Jenkins to create AMI using Packer"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name = "JenkinsPackerInlinePolicy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ec2:AttachVolume",
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:CopyImage",
            "ec2:CreateImage",
            "ec2:CreateKeyPair",
            "ec2:CreateSecurityGroup",
            "ec2:CreateSnapshot",
            "ec2:CreateTags",
            "ec2:CreateVolume",
            "ec2:DeleteKeyPair",
            "ec2:DeleteSecurityGroup",
            "ec2:DeleteSnapshot",
            "ec2:DeleteVolume",
            "ec2:DeregisterImage",
            "ec2:DescribeImageAttribute",
            "ec2:DescribeImages",
            "ec2:DescribeInstances",
            "ec2:DescribeInstanceStatus",
            "ec2:DescribeRegions",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSnapshots",
            "ec2:DescribeSubnets",
            "ec2:DescribeTags",
            "ec2:DescribeVolumes",
            "ec2:DetachVolume",
            "ec2:GetPasswordData",
            "ec2:ModifyImageAttribute",
            "ec2:ModifyInstanceAttribute",
            "ec2:ModifySnapshotAttribute",
            "ec2:RegisterImage",
            "ec2:RunInstances",
            "ec2:StopInstances",
            "ec2:TerminateInstances"
          ],
          "Resource" : "*"
        }
      ]
    })
  }

  tags = var.default_tags
}

resource "aws_iam_instance_profile" "ec2_jenkins_instance_profile" {
  name = "JenkinsPackerInstanceProfile"
  role = aws_iam_role.ec2_jenkins_role.name

  tags = var.default_tags
}
