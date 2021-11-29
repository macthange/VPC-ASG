locals {

  name       = "my-project"
  owner      = "my-Project@example.com"
  enabled    = "true"
  prefix     = local.name
  account_id = data.aws_caller_identity.current.account_id
  aws_region = data.aws_region.current.name

  region_code = lookup(var.region_code, var.region)

  common_tags = {
    prefix           = local.name
    resource-owner   = local.owner
    environment-type = var.aws_environment

  }

  kms_key        = "${local.prefix}-kms-key-${var.env}-${local.region_code}"
  s3_bucket_name = "${local.prefix}-s3-log-bucket-${var.env}-${local.region_code}"
  nlb_name       = "${local.prefix}-nlb${var.env}-${local.region_code}"
  nlb_tg_name    = "${local.prefix}-nlb-tg-${var.env}-${local.region_code}"

}