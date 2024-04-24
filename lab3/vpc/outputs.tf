output "nat_public_ip" {
  value = module.vpc_with_nat_instance.nat_public_ip
}

output "vpc_id" {
  value = module.vpc_with_nat_instance.vpc_id
}

output "vpc_cidr" {
  value = module.vpc_with_nat_instance.vpc_cidr
}

output "public_subnet_id" {
  description = "The main public subnet ID"
  value       = module.vpc_with_nat_instance.public_subnet_id
}

output "other_public_subnet_id" {
  description = "The other public subnet ID"
  value       = aws_subnet.public_2.id
}

output "private_subnet_id" {
  description = "The main private subnet ID"
  value       = module.vpc_with_nat_instance.private_subnet_id
}

output "database_subnet_ids" {
  description = "List of subnet IDs for the RDS instance"
  value       = module.vpc_with_nat_instance.database_subnet_ids
}

output "sg_nat_id" {
  description = "The Security Group ID of the NAT instance"
  value       = module.vpc_with_nat_instance.sg_nat_id
}
