data "aws_ami" "rhel9" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "image-id"
    values = ["ami-0014871499315f25a"]
  }
}
