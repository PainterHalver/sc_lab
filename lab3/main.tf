module "vpc" {
  source                  = "./vpc"
  aws_availability_zone   = var.aws_availability_zone
  aws_availability_zone_2 = var.aws_availability_zone_2
  ssh_pubkey_path         = var.ssh_pubkey_path

  default_tags = var.default_tags
}

module "jenkins" {
  source                 = "./jenkins"
  aws_region             = var.aws_region
  aws_availability_zone  = var.aws_availability_zone
  ssh_pubkey_path        = var.ssh_pubkey_path
  vpc_id                 = module.vpc.vpc_id
  public_subnet_id       = module.vpc.public_subnet_id
  other_public_subnet_id = module.vpc.other_public_subnet_id
  private_subnet_id      = module.vpc.private_subnet_id

  default_tags = var.default_tags
}
