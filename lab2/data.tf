data "aws_ami" "centos_stream_9" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["CentOS-Stream-ec2-9-*"]
  }
}
