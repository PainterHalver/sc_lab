# module "vpc" {
#   source              = "../modules/vpc"
#   aws_region          = var.aws_region
#   vpc_cidr            = "10.100.0.0/16"
#   public_subnet_cidr  = "10.100.0.0/24"
#   private_subnet_cidr = "10.100.1.0/24"
#   subnet_az           = var.aws_availability_zone
# }

resource "aws_default_subnet" "default_az1" {
  availability_zone = var.aws_availability_zone
}

resource "aws_key_pair" "ssh_pubkey" {
  key_name   = "ssh-pubkey-jenkins"
  public_key = file(var.ssh_pubkey_path)

  tags = var.default_tags
}

resource "aws_key_pair" "jenkins_agent_key_pair" {
  key_name   = "jenkins-agent-key"
  public_key = file("${path.module}/misc/jenkins_agent.pem.pub")
}
