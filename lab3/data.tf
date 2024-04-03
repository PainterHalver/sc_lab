data "aws_ami" "rhel9" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "image-id"
    values = ["ami-09b1e8fc6368b8a3a"]
  }
}
