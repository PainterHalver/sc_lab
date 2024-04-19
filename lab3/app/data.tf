data "aws_ami" "auto_scaling_group_ami" {
  most_recent = true
  owners      = ["self", "679593333241"] // TODO: remove testing centos

  filter {
    name   = "name"
    values = ["CentOS-9-App-*", "CentOS-Stream-ec2-9-*"]
  }
}
