variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The The Aws region where this resource wuill be deployed "
}

variable "region_code" {
  description = "Region code"
  default = {
    us-east-1 = "use1"
    us-west-1 = "usw1"
  }
}
#
#

# Options available
# SYMMETRIC_DEFAULT, RSA_2048, RSA_3072,
# RSA_4096, ECC_NIST_P256, ECC_NIST_P384,
# ECC_NIST_P521, or ECC_SECG_P256K1
variable key_spec {
  default = "SYMMETRIC_DEFAULT"
}
variable "env" {
  type        = string
  default     = "poc"
  description = "The Environment where this resource wuill be deployed "
}
variable "aws_environment" {
  type = map(string)
  default = {
    dev  = "DEVELOPMENT"
    qa   = "QUALITY ASSURANCE"
    ppe  = "PRE-PRODUCTION"
    prod = "PRODUCTION"
  }
}
variable "deployer_role" {
  type        = string
  default     = "poc"
  description = "The role will be used resource deployment"
}


variable enabled {
  default = true

}

variable rotation_enabled {
  default = true
}



variable kms_alias_name {
  default     = ""
  description = "name for kms key id"
}

variable policy {
  default     = ""
  description = "kms plocy json"
}

variable "tags" {
  type        = map
  default     = {}
  description = "tags for resource "
}
