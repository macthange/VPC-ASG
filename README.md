AWS VPC Terraform module
Terraform module which creates VPC resources on AWS.

Usage

module "networking" {
  source  = "./modules/networking"
  name    = local.name
  owner   = local.owner
  enabled = local.enabled
}


#### All varible are stored in local.tf
 1) you Need to use git Bash if yuo are using windos 
 2) it will work with mac and linux shell


# cd scripts you will presented 4 files 
tf_init.sh
tf_plan.sh
tf_apply.sh
tf_destroy.sh
### Example ###
cd  ../
AWS_PROFILE=default \
 terraform init -reconfigure -upgrade \
-backend-config=./terraform.backendconfig

## modify profile value ans you are redy to go 
   AWS_PROFILE=<default>
   1) sh tf_init.sh  ## This will do terraform init 
   2) sh tf_plan.sh  ## This will do terraform Plan 
   3) sh tf_apply.sh  ## This will do terraform apply 
   4) sh tf_destroy.sh ## This will do terraform destroy 
   