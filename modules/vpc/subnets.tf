resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.subnet_az
  map_public_ip_on_launch = true

  tags = merge(var.default_tags, {
    "Name" = "Public Subnet"
  })
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.subnet_az

  tags = merge(var.default_tags, {
    "Name" = "Private Subnet"
  })
}

resource "aws_subnet" "database" {
  count             = length(var.database_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.database_subnets[count.index].cidr_block
  availability_zone = var.database_subnets[count.index].availability_zone

  tags = merge(var.default_tags, {
    "Name" = "Database Subnet"
  })
}