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
#
# Options available
# SYMMETRIC_DEFAULT, RSA_2048, RSA_3072,
# RSA_4096, ECC_NIST_P256, ECC_NIST_P384,
# ECC_NIST_P521, or ECC_SECG_P256K1
variable key_spec {
  default = "SYMMETRIC_DEFAULT"
}

variable enabled {
  default = false

}
variable s3_destroy {
  default = false

}


variable rotation_enabled {
  default = true
}



variable alias {
  default     = ""
  description = "name for kms key id"
}

variable policy {
  default     = ""
  description = "kms plocy json"
}



variable "s3_enabled" {
  default     = "false"
  description = "do you want to dep,ly resource default false do nothing true will delpy the resource"
}
variable "aws_kms_key_arn" {
  default     = ""
  type        = string
  description = "The KMS key whic ic used for s3 encription resource"
}
