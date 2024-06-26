module "vpc_with_nat_instance" {
  source              = "../../modules/vpc"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.0.0/24"
  private_subnet_cidr = "10.0.1.0/24"
  subnet_az           = var.aws_availability_zone
  with_nat_instance = {
    enabled                   = true
    ssh_pubkey_path           = var.ssh_pubkey_path
    export_cloudwatch_metrics = false
    instance_profile_name     = null
  }
  database_subnets = [
    {
      cidr_block        = "10.0.2.0/24"
      availability_zone = var.aws_availability_zone
    },
    {
      cidr_block        = "10.0.3.0/24"
      availability_zone = var.aws_availability_zone_2
    }
  ]
  default_tags = var.default_tags
}

// Add another public subnet because ALB requires at least two subnets
resource "aws_subnet" "public_2" {
  vpc_id            = module.vpc_with_nat_instance.vpc_id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.aws_availability_zone_2

  tags = merge(var.default_tags, {
    "Name" = "Public Subnet 2"
  })
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = module.vpc_with_nat_instance.public_subnet_route_table_id
}

// Add a VPC Gateway Endpoint for S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc_with_nat_instance.vpc_id
  vpc_endpoint_type = "Gateway"

  service_name = "com.amazonaws.${var.aws_region}.s3"

  route_table_ids = [
    module.vpc_with_nat_instance.public_subnet_route_table_id,
    module.vpc_with_nat_instance.private_subnet_route_table_id
  ]

  tags = var.default_tags
}
