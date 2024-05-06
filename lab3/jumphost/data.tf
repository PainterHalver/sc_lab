data "aws_ami" "jumphost" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["CentOS-9-Jumphost-*"]
  }
}
