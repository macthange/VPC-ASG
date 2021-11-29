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


variable "prefix" {
  description = "Application asset insight ID used for proper naming"
  default     = ""
}
variable "vpc_id" {
  description = "AWS VPC to use"
  default     = ""
}

variable "tags" {
  description = "Tags to apply to AWS resources"
  default     = {}
}
