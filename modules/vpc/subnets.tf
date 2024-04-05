resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.subnet_az
  map_public_ip_on_launch = true

  tags = merge(var.default_tags, {
    "Name" = "Public Subnet"
  })
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.subnet_az

  tags = merge(var.default_tags, {
    "Name" = "Private Subnet"
  })
}
