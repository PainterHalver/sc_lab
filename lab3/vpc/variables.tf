variable "aws_availability_zone" {
  description = "The availability zone to deploy resources"
  nullable    = false
}

variable "aws_availability_zone_2" {
  description = "The AZ to deploy the second private subnet in, this is needed for RDS and should be different from the first AZ"
  nullable    = false
}

variable "default_tags" {
  description = "The default tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "ssh_pubkey_path" {
  description = "The public key path for the NAT instance"
  type        = string
}
