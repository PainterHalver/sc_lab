module "vpc" {
  source                  = "./vpc"
  aws_availability_zone   = var.aws_availability_zone
  aws_availability_zone_2 = var.aws_availability_zone_2
  ssh_pubkey_path         = var.ssh_pubkey_path

  default_tags = var.default_tags
}
