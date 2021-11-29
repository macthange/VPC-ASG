provider "aws" {
  region = var.region
}
#------------------------------------------------------------------------------
# Terraform settings
#------------------------------------------------------------------------------
terraform {
  required_providers {
    aws = "<= 3.53.0"
  }

  /*  
  #backend "s3" {
   dynamodb_table = "my-vpc-master-terraform-state-lock"    
   encrypt        = true
   bucket         = "my-vpc-master-terraform-state-lock-us-east-1""
    region         = "us-east-1"
    key            = "my-project.tfstate"
} 
*/
  backend "local" {}
}
module "networking" {
  source  = "./modules/networking"
  region  = data.aws_region.current.name
  enabled = "true"
  env     = var.env
  name    = local.name
  owner   = local.owner

}

module "kms_key" {
  source         = "./modules/kms_key"
  env            = var.env
  enabled        = "true"
  deployer_role  = var.deployer_role
  kms_alias_name = "alias/${local.kms_key}"

}

module "s3_bucket" {
  source          = "./modules/s3_bucket"
  env             = var.env
  s3_enabled      = "true"
  aws_kms_key_arn = module.kms_key.kms_key_arn
}



module "securit_group" {
  source = "./modules/security_group"
  env    = var.env


}

module "app_srv" {
  source             = "./modules/app_srv"
  env                = var.env
  kms_master_key_arn = module.kms_key.kms_key_arn
  vpc_id             = module.networking.vpc_id
  subnet_ids         = module.networking.public_subnets_id
  private_zone_id    = module.networking.private_zone_id
  private_zone_name   = module.networking.private_zone_name
  log_bucket_id      = module.s3_bucket.s3_bucket_id
  image_id           = data.aws_ami.golden_image.id
  security_group     = [module.securit_group.app-sg]
  instance_type      = "c5.large"
  user_data = templatefile("${path.module}/templates/userdata.sh",
  { region_code = local.region_code })
}

module "web_srv" {
  source             = "./modules/web_srv"
  env                = var.env
  kms_master_key_arn = module.kms_key.kms_key_arn
  vpc_id             = module.networking.vpc_id
  subnet_ids         = module.networking.public_subnets_id
  public_zone_id    = module.networking.public_zone_id
  public_zone_name    = module.networking.public_zone_name
  log_bucket_id      = module.s3_bucket.s3_bucket_id
  security_group     = [module.securit_group.web-sg]
  alb_security_group = [module.securit_group.alb-sg]
  image_id           = data.aws_ami.golden_image.id
  instance_type      = "c5.large"
  user_data = templatefile("${path.module}/templates/userdata.sh",
  { region_code = local.region_code })
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}


module "pg_rds" {
  source                  = "./modules/pg_rds"
  vpc_id                  = module.networking.vpc_id
  db_security_group       = [module.securit_group.db_sg]
  subnet_group            = module.networking.rds_subnet_group[0]
  env                     = var.env
  database_name           = "mytestdb-${var.env}"
  database_username       = "dbadmin"
  database_password       = random_password.password.result
  database_identifier     = "mytestdb-${var.env}"
  multi_availability_zone = "true"
  private_zone_id    = module.networking.private_zone_id
  private_zone_name    = module.networking.private_zone_name

}
