packer {
  required_plugins {
    aws = {
      version = "~> 1.3.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "hip_ami_id" {
  type    = string
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  region    = "ap-southeast-1"
}

source "amazon-ebs" "hip" {
  ami_name      = "CentOS-9-Base-${local.timestamp}"
  instance_type = "t2.micro"
  region        = local.region
  ssh_username  = "ec2-user"
  source_ami    = var.hip_ami_id
}

build {
  name = "build-base-ami"
  sources = [
    "source.amazon-ebs.hip"
  ]

  provisioner "shell" {
    execute_command = "sudo -E -S sh '{{ .Path }}'"
    inline = [templatefile("./scripts/base_ami.sh", {  })]
  }
}
