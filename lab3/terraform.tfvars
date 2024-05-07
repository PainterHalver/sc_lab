aws_region              = "ap-southeast-1"
aws_availability_zone   = "ap-southeast-1a"
aws_availability_zone_2 = "ap-southeast-1b"
instance_type           = "t2.micro"
ssh_pubkey_path         = "~/.ssh/id_rsa.pub"

default_tags = {
  "Group"       = "CyberDevOps",
  "Environment" = "Development"
}
