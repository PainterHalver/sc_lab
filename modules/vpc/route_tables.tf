resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  route {
    cidr_block = aws_vpc.vpc.cidr_block
    gateway_id = "local"
  }
}

resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = aws_vpc.vpc.cidr_block
    gateway_id = "local"
  }
}

// Attach to subnets
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}
