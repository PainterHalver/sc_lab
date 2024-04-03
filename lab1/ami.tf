data "aws_ami" "rhel9" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "image-id"
    values = ["ami-09b1e8fc6368b8a3a"]
  }
}
