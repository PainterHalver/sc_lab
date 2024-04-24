output "vpc_id" {
  value = module.vpc_with_nat_instance.vpc_id
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
