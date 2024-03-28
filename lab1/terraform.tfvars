aws_region            = "ap-northeast-1"
aws_availability_zone = "ap-northeast-1a"
instance_type         = "t2.micro"
ssh_pubkey_path       = "~/.ssh/id_rsa.pub"

default_tags = {
  "CreatedBy" = "Terraform",
  "Lab"       = "1"
}
