module "vpc_app" {
  source              = "../modules/vpc"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.0.0/24"
  private_subnet_cidr = "10.0.1.0/24"
  subnet_az           = var.aws_availability_zone
  default_tags        = var.default_tags
}

module "vpc_ldap" {
  source              = "../modules/vpc"
  vpc_cidr            = "10.1.0.0/16"
  public_subnet_cidr  = "10.1.0.0/24"
  private_subnet_cidr = "10.1.1.0/24"
  subnet_az           = var.aws_availability_zone
  with_nat_instance = {
    enabled                   = true
    ssh_pubkey_path           = var.ssh_pubkey_path
    export_cloudwatch_metrics = false
    instance_profile_name     = null
  }
  default_tags = var.default_tags
}

resource "aws_key_pair" "ssh_pubkey" {
  key_name   = "ssh-pubkey"
  public_key = file(var.ssh_pubkey_path)
}
