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
  ami_name      = "CentOS-9-BaseAMI-${local.timestamp}"
  instance_type = "t2.micro"
  region        = local.region
  source_ami    = "ami-07dc7fbc73bffbeb5" # CentOS Stream 9
  ssh_username  = "ec2-user"
}

build {
  name = "build-jenkins-ami"
  sources = [
    "source.amazon-ebs.centos_stream_9"
  ]

  provisioner "shell" {
    execute_command = "sudo -E -S sh '{{ .Path }}'"
    inline = [templatefile("${path.root}/../user-data/base_ami.sh", {  })]
  }

  // Push latest data to s3 after creating the AMI: s3://hip.daohiep.me/images/aws/centos/latest
  post-processors {
    post-processor "manifest" {
      output     = "manifest.json"
      strip_path = true
    }

    post-processor "shell-local" {
      inline = [
        "AMI_ID=$(jq -r '.builds[-1].artifact_id' manifest.json | cut -d \":\" -f2)",
        "echo $AMI_ID > ami_id.txt",
        "aws s3 cp ami_id.txt s3://hip.daohiep.me/images/aws/centos/latest",
        "rm -f ami_id.txt manifest.json"
      ]
    }
  }
}
