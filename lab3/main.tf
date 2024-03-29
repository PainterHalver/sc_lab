module "vpc" {
  source              = "../modules/vpc"
  aws_region          = var.aws_region
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.0.0/24"
  private_subnet_cidr = "10.0.1.0/24"
  subnet_az           = var.aws_availability_zone
}


resource "aws_key_pair" "ssh_pubkey" {
  key_name   = "ssh-pubkey"
  public_key = file(var.ssh_pubkey_path)

  tags = var.default_tags
}
