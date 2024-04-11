data "aws_ami" "centos_stream_9" {
  most_recent = true
  owners      = ["679593333241", "self"]

  filter {
    name   = "name"
    values = ["CentOS-9-Jenkins-*", "CentOS-9-BaseAMI-*", "CentOS-Stream-ec2-9-*"]
  }
}
