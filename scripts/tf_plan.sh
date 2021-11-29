cd ../
AWS_PROFILE=servicenow-sdlc-preprod \
terraform plan \
-input=false \
-var-file=./terraform.tfvars -var 'env=dev' \
-out="jenkins.tfplan" 
