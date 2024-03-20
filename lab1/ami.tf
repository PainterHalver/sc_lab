data "aws_ami" "rhel9" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "image-id"
    values = ["ami-0014871499315f25a"]
  }
}
