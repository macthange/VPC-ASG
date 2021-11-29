locals {

  name       = "my-project"
  owner      = "my-Project@example.com"
  enabled    = "true"
  prefix     = local.name
  account_id = data.aws_caller_identity.current.account_id
  aws_region = data.aws_region.current.name
  region     = data.aws_region.current.name

  region_code = lookup(var.region_code, local.region)

  common_tags = {
    prefix           = local.name
    resource-owner   = local.owner
    environment-type = var.aws_environment

  }

  kms_key        = "${local.prefix}-kms-key-${var.env}-${local.region_code}"
  s3_bucket_name = "${local.prefix}-s3-log-bucket-${var.env}-${local.region_code}"

  
  alb_name         = "${local.prefix}-alb${var.env}-${local.region_code}"
  alb_tg_name      = "${local.prefix}-alb-tg-${var.env}-${local.region_code}"
  alb_listner_name = "${local.prefix}-alb-tg-${var.env}-${local.region_code}"
  alb_lt_name      = "${local.prefix}-alb-lt-${var.env}-${local.region_code}"
  alb_asg_name     = "${local.prefix}-alb-asg-${var.env}-${local.region_code}"
  asg_iam_role_name = "${local.prefix}-alb-iam-${var.env}-${local.region_code}"


}