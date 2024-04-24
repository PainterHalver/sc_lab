aws_region            = "ap-southeast-1"
aws_availability_zone = "ap-southeast-1a"
instance_type         = "t2.micro"
ssh_pubkey_path       = "~/.ssh/id_rsa.pub"

default_tags = {
  "CreatedBy"   = "Terraform",
  "Lab"         = "3",
  "Group"       = "CyberDevOps",
  "Environment" = "Development"
}
