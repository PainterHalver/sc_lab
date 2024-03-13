variable "instance_type" {
  description = "The general type of instance to launch"
  default = "t2.micro"
}

variable "ssh_pubkey_path" {
  description = "The path to the public key used for SSH access"
  default = "~/.ssh/id_rsa.pub"
}

variable "default_tags" {
  description = "The default tags to apply to all resources"
  type = map(string)
  default = {}
}

variable "ldap_domain" {
  description = "The domain name of the LDAP server"
  default = "ldap.daohiep.me"
}

variable "ldap_admin_password" {
  description = "The password for the LDAP admin user"
  # default = "admin"
}
