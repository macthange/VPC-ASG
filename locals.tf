locals {

  name    = "my-project"
  owner   = "my-Project@example.com"
  enabled = "true"
  prefix  = local.name

  region_code = lookup(var.region_code, var.region)
  common_tags = {
    prefix           = local.name
    resource-owner   = local.owner
    environment-type = var.aws_environment

  }

  kms_key = "${local.prefix}-kms-key-${var.env}-${local.region_code}"


}