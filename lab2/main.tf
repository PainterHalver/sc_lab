module "vpc_with_nat_instance" {
  source              = "../modules/vpc"
  aws_region          = var.aws_region
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.0.0/24"
  private_subnet_cidr = "10.0.1.0/24"
  subnet_az           = var.aws_availability_zone
  with_nat_instance = {
    enabled                   = true
    ssh_pubkey_path           = var.ssh_pubkey_path
    export_cloudwatch_metrics = true
    instance_profile_name     = module.ec2_cloudwatch_profile.profile_name
  }
  default_tags = var.default_tags
}


resource "aws_key_pair" "ssh_pubkey" {
  key_name   = "ssh-pubkey"
  public_key = file(var.ssh_pubkey_path)

  tags = var.default_tags
}
