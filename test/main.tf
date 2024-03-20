module "vpc_1" {
  source = "../modules/vpc"
  aws_region = "ap-northeast-1"
  vpc_cidr = "192.168.0.0/16"
  public_subnet_cidr = "192.168.0.0/24"
  private_subnet_cidr = "192.168.1.0/24"
  subnet_az = "ap-northeast-1a"
}
