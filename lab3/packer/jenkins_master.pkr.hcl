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

source "amazon-ebs" "centos_stream_9" {
  ami_name      = "CentOS-9-Jenkins-${local.timestamp}"
  instance_type = "t2.micro"
  region        = local.region
  ssh_username  = "ec2-user"

  # CentOS Stream 9: ami-07dc7fbc73bffbeb5
  source_ami_filter {
    filters = {
      name   = "CentOS-9-Base-*, CentOS-Stream-ec2-9-*" // CentOS-Stream-ec2-9-* for first time demo
    }
    most_recent = true
    owners      = ["679593333241", "self"]
  }
}

build {
  name = "build-jenkins-ami"
  sources = [
    "source.amazon-ebs.centos_stream_9"
  ]

  provisioner "shell" {
    execute_command = "sudo -E -S sh '{{ .Path }}'"
    inline = [templatefile("${path.root}/scripts/jenkins_master.sh", {  })]
  }
}
