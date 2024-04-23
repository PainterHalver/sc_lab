aws_region              = "ap-southeast-1"
aws_availability_zone   = "ap-southeast-1a"
aws_availability_zone_2 = "ap-southeast-1b"
instance_type           = "t2.micro"
ssh_pubkey_path         = "~/.ssh/id_rsa.pub"
db_admin_user           = "admin"
db_admin_password       = "admin123"
app_git_commit_hash     = "random_hash"

default_tags = {
  "CreatedBy"   = "Terraform_App",
  "Lab"         = "3",
  "Group"       = "CyberDevOps",
  "Environment" = "Development"
}
