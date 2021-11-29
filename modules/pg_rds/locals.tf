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

  kms_key          = "${local.prefix}-kms-key-${var.env}-${local.region_code}"
  s3_bucket_name   = "${local.prefix}-s3-log-bucket-${var.env}-${local.region_code}"
  nlb_name         = "${local.prefix}-nlb${var.env}-${local.region_code}"
  nlb_tg_name      = "${local.prefix}-nlb-tg-${var.env}-${local.region_code}"
  nlb_listner_name = "${local.prefix}-nlb-tg-${var.env}-${local.region_code}"
  nlb_lt_name      = "${local.prefix}-nlb-lt-${var.env}-${local.region_code}"
  nlb_asg_name     = "${local.prefix}-nlb-asg-${var.env}-${local.region_code}"
  rds_iam_role     = "${local.prefix}-pg-rds-monitor-${var.env}-${local.region_code}"

}