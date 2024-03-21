output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "nat_public_ip" {
  value = aws_instance.ec2_nat.public_ip
}

output "vpc_cidr" {
  value = var.vpc_cidr
}
