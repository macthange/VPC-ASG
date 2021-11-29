cd ../
AWS_PROFILE=default \
terraform destroy -input=false -auto-approve \
-var-file=./terraform.tfvars 
