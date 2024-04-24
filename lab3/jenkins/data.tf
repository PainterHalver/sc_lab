data "aws_ami" "jenkins" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["CentOS-9-Jenkins-*", ]
  }
}

data "aws_ami" "jenkins_agent" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["CentOS-Stream-ec2-9-*"]
  }
}

data "aws_ami" "centos_9_stream" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["CentOS-Stream-ec2-9-*"]
  }
}
