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
  value = var.with_nat_instance.enabled ? aws_instance.ec2_nat[0].public_ip : null
}

output "nat_private_dns" {
  value = var.with_nat_instance.enabled ? aws_instance.ec2_nat[0].private_dns : null
}

output "vpc_cidr" {
  value = var.vpc_cidr
}
