login:
	aws sso login

init:
	terraform init -backend-config="backends/sandbox.backend" -reconfigure 

plan: 
	terraform plan -var-file="sandbox.tfvars"

apply:
	terraform apply -var-file="sandbox.tfvars" -auto-approve

destroy:
	terraform destroy -var-file="sandbox.tfvars" -auto-approve
