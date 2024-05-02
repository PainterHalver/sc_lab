data "aws_ami" "jumphost" {
  most_recent = true
  owners      = ["679593333241", "self"]

  filter {
    name   = "name"
    values = ["CentOS-9-Jumphost-*", "CentOS-Stream-ec2-9-*"] // Use jumphost AMI if it exists
  }
}
