data "aws_ami" "app" {
  most_recent = true
  owners      = ["self", "679593333241"] // TODO: remove testing centos

  filter {
    name   = "name"
    values = ["CentOS-9-App-*", "CentOS-Stream-ec2-9-*"]
  }
}
