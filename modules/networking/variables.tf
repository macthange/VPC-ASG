variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The The Aws region where this resource wuill be deployed "
}


variable "name" {
  type        = string
  default     = "demo"
  description = "Name prefix for eatch resource"

}
variable "owner" {
  type        = string
  default     = "demo"
  description = "The Name/Email ID of owner to resposible for support & billing"
}

variable "enabled" {
  type        = bool
  default     = false
  description = "Name prefix for eatch resource"
}

variable "region_number" {
  # Arbitrary mapping of region name to number to use in
  # a VPC's CIDR prefix.
  default = {
    us-east-1      = 1
    us-west-1      = 2
    us-west-2      = 3
    eu-central-1   = 4
    ap-northeast-1 = 5


  }
}


variable "env" {
  type        = string
  default     = "demo"
  description = "Name prefix for eatch resource"
}


variable "resource_count" {
  # Arbitrary mapping of region name to number to use in
  # a VPC's resource prefix.
  default = {
    admin   = 2
    prod    = 3
    dev     = 2
    staging = 2
    sandbox = 2


  }
}