data "aws_ami" "centos_stream_9" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["CentOS-9-Jenkins-*", ]
  }
}
