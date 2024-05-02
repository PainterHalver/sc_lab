.PHONY: all delete-ami apply-vpc check

SHELL=/bin/bash -exo pipefail
MAKEFLAGS += --silent

all:
	echo "Please specify a target to run."

delete-ami:
	python3 resources/misc/delete_all_amis.py 

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
