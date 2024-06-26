module "vpc" {
  source                  = "./vpc"
  aws_region              = var.aws_region
  aws_availability_zone   = var.aws_availability_zone
  aws_availability_zone_2 = var.aws_availability_zone_2
  ssh_pubkey_path         = var.ssh_pubkey_path

  default_tags = var.default_tags
}

resource "aws_route53_zone" "private" {
  name = "go"

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  depends_on = [ module.vpc ]
  tags = var.default_tags
}

module "efs" {
  source                = "./efs"
  aws_availability_zone = var.aws_availability_zone
  vpc_id                = module.vpc.vpc_id
  vpc_cidr              = module.vpc.vpc_cidr
  subnet_id             = module.vpc.private_subnet_id

  default_tags = var.default_tags
  depends_on   = [module.vpc]
}

module "jumphost" {
  source          = "./jumphost"
  instance_type   = var.instance_type
  vpc_id          = module.vpc.vpc_id
  subnet_id       = module.vpc.public_subnet_id
  ssh_pubkey_path = var.ssh_pubkey_path
  efs_dns_name    = module.efs.dns_name

  default_tags = var.default_tags
  depends_on   = [module.vpc, module.efs]
}

module "sonarqube" {
  source                 = "./sonarqube"
  ssh_pubkey_path        = var.ssh_pubkey_path
  vpc_id                 = module.vpc.vpc_id
  public_subnet_id       = module.vpc.public_subnet_id
  other_public_subnet_id = module.vpc.other_public_subnet_id
  private_subnet_id      = module.vpc.private_subnet_id
  efs_dns_name           = module.efs.dns_name
  route53_zone_id = aws_route53_zone.private.zone_id
  route53_zone_name = aws_route53_zone.private.name

  default_tags = var.default_tags
  depends_on   = [module.vpc, module.efs, aws_route53_zone.private]
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
  efs_dns_name           = module.efs.dns_name
  sonarqube_url          = module.sonarqube.url
  route53_zone_id = aws_route53_zone.private.zone_id
  route53_zone_name = aws_route53_zone.private.name

  default_tags = var.default_tags
  depends_on   = [module.vpc, module.efs, module.sonarqube]
}

module "app" {
  source                 = "./app"
  aws_region             = var.aws_region
  aws_availability_zone  = var.aws_availability_zone
  ssh_pubkey_path        = var.ssh_pubkey_path
  instance_type          = var.instance_type
  vpc_id                 = module.vpc.vpc_id
  sg_nat_id              = module.vpc.sg_nat_id
  public_subnet_id       = module.vpc.public_subnet_id
  other_public_subnet_id = module.vpc.other_public_subnet_id
  private_subnet_id      = module.vpc.private_subnet_id
  database_subnet_ids    = module.vpc.database_subnet_ids
  app_git_commit_hash    = var.app_git_commit_hash
  route53_zone_id = aws_route53_zone.private.zone_id
  route53_zone_name = aws_route53_zone.private.name

  default_tags = var.default_tags
  depends_on   = [module.vpc]
}
