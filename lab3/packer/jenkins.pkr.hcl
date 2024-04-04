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

source "amazon-ebs" "rhel9" {
  ami_name      = "jenkins-ami-${local.timestamp}"
  instance_type = "t2.micro"
  region        = local.region
  source_ami    = "ami-09b1e8fc6368b8a3a"
  ssh_username  = "ec2-user"
}

build {
  name = "build-jenkins-ami"
  sources = [
    "source.amazon-ebs.rhel9"
  ]

  provisioner "shell" {
    execute_command = "sudo -E -S sh '{{ .Path }}'"
    inline = [templatefile("${path.root}/../user-data/jenkins.sh", {  })]
  }
}