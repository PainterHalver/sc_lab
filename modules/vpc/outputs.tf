output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "nat_public_ip" {
  value = var.with_nat_instance.enabled ? aws_instance.nat[0].public_ip : null
}

output "vpc_cidr" {
  value = var.vpc_cidr
}

output "nat_private_dns" {
  value = var.with_nat_instance.enabled ? aws_instance.nat[0].private_dns : null
}

output "sg_nat_id" {
  value = var.with_nat_instance.enabled ? aws_security_group.nat[0].id : null
}

output "database_subnet_ids" {
  value = aws_subnet.database[*].id
}

output "public_subnet_route_table_id" {
  value = aws_route_table.public.id
}

output "private_subnet_route_table_id" {
  value = aws_route_table.private.id
}
