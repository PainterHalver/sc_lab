packer {
  required_plugins {
    aws = {
      version = "~> 1.3.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  region    = "ap-southeast-1"
}

source "amazon-ebs" "base" {
  ami_name      = "CentOS-9-Jumphost-${local.timestamp}"
  instance_type = "t2.micro"
  region        = local.region
  ssh_username  = "ec2-user"

  source_ami_filter {
    filters = {
      name   = "CentOS-9-Base-*"
    }
    most_recent = true
    owners      = ["self"]
  }
}

build {
  name = "build-jumphost-ami"
  sources = [
    "source.amazon-ebs.base"
  ]

  provisioner "shell" {
    execute_command = "sudo -E -S sh '{{ .Path }}'"
    inline = [templatefile("./scripts/jumphost.sh", {  })]
  }
}
