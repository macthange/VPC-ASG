variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The The Aws region where this resource wuill be deployed "
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "The VPC ID where  this resource will be deployed "
}
variable "kms_master_key_arn" {
  type        = string
  default     = ""
  description = "kms_master_key_arn resource kms encription"
}
variable "log_bucket_id" {
  type        = string
  default     = ""
  description = "The Bucket ID where  this resource log will be dstored"
}
variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs to associate with NLB"
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


################ASG###########

variable "create_lt" {
  type        = bool
  default     = true
  description = "A boolean flag to determine whether the NLB should be internal"
}
variable "lt_use_name_prefix" {
  type        = bool
  default     = true
  description = "A boolean flag to determine whether the NLB should be internal"
}
variable "type" {
  type        = bool
  default     = true
  description = "Type of Load Balance to name prefix"
}


variable "ec2_hard_drive_size" {
  type        = number
  default     = 10
  description = "The port for the TCP listener"
}

variable "user_data" {
  default     = ""
  type        = string
  description = "AMI ID for ASG Ec2 resource"
}
variable "image_id" {
  default     = ""
  type        = string
  description = "AMI ID for ASG Ec2 resource"
}
variable "instance_type" {
  default     = ""
  type        = string
  description = "instance type for ASG Ec2 resource"
}
variable "security_group" {
  type        = list(string)
  default     = []
  description = "A list of additional security group IDs to allow access to ALB"
}
variable "aws_subnet" {
  type        = list(string)
  default     = []
  description = "A list of additional security group IDs to allow access to ALB"
}


variable "ip_address_type" {
  default     = "ipv4"
  type        = string
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack"
}

variable "deletion_protection_enabled" {
  type        = bool
  default     = false
  description = "deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false."
}

variable "drop_invalid_header_fields" {
  type        = bool
  default     = false
  description = "HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false). The default is false."
}


variable "private_zone_id" {
  type        = string
  default     = "poc"
  description = "private_zone_id for LB route53 record"
}


variable "private_zone_name" {
  type        = string
  default     = "poc"
  description = "private_zone_id for LB route53 record"
}
variable "public_zone_id" {
  type        = string
  default     = "poc"
  description = "public_zone_id for LB route53 record"
}


variable "public_zone_name" {
  type        = string
  default     = "poc"
  description = "private_zone_id for LB route53 record"
}