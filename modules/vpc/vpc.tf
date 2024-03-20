resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true // Default
  enable_dns_hostnames = true // Default false

  tags = merge(
    {
      "Name" = "Terraform VPC"
    },
    var.default_tags
  )
}
