.PHONY: all delete-ami apply-vpc check

SHELL=/bin/bash -exo pipefail
MAKEFLAGS += --silent

all:
	echo "Please specify a target to run."

delete-ami:
	python3 resources/misc/delete_all_amis.py

base-ami:
	packer build -var hip_ami_id=ami-07dc7fbc73bffbeb5 resources/packer/base_ami.pkr.hcl

jenkins-ami:
	packer build resources/packer/jenkins_master.pkr.hcl

jumphost-ami:
	packer build resources/packer/jumphost.pkr.hcl

app-ami:
	packer build resources/packer/app.pkr.hcl

check:
	terraform fmt -check=true -recursive
	terraform validate

apply-vpc:
	terraform apply -target=module.vpc

destroy-vpc:
	terraform destroy -target=module.vpc

destroy:
	terraform destroy

destroy-now:
	terraform destroy -auto-approve

apply:
	terraform apply