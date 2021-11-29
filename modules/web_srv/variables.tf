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
  description = "A list of additional security group IDs to allow access ALB to web"
}
variable "alb_security_group" {
  type        = list(string)
  default     = []
  description = "A list of additional security group IDs to allow access to ALB"
}


variable "aws_subnet" {
  type        = list(string)
  default     = []
  description = "A list of additional security group IDs to allow access to ALB"
}

variable "idle_timeout" {
  type        = number
  default     = 60
  description = "The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type application. Default: 60."
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
variable "listener_https_fixed_response" {
  description = "Have the HTTPS listener return a fixed response for the default action."
  type = object({
    content_type = string
    message_body = string
    status_code  = string
  })
  default = null
}
variable "https_ssl_policy" {
  type        = string
  description = "The name of the SSL Policy for the listener"
  default     = "ELBSecurityPolicy-2015-05"
}
variable "target_group_target_type" {
  type        = string
  default     = "ip"
  description = "The type (`instance`, `ip` or `lambda`) of targets that can be registered with the target group"
}
variable "deregistration_delay" {
  type        = number
  default     = 90
  description = "The amount of time to wait in seconds before changing the state of a deregistering target to unused"
}
variable "health_check_path" {
  type        = string
  default     = "/"
  description = "The destination for the health check request"
}
variable "health_check_timeout" {
  type        = number
  default     = 10
  description = "The amount of time to wait in seconds before failing a health check request"
}

variable "health_check_healthy_threshold" {
  type        = number
  default     = 2
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
}

variable "health_check_unhealthy_threshold" {
  type        = number
  default     = 2
  description = "The number of consecutive health check failures required before considering the target unhealthy"
}

variable "health_check_interval" {
  type        = number
  default     = 15
  description = "The duration in seconds in between health checks"
}

variable "health_check_matcher" {
  type        = string
  default     = "200-399"
  description = "The HTTP response codes to indicate a healthy check"
}

variable "additional_certs" {
  type        = list(string)
  description = "A list of additonal certs to add to the https listerner"
  default     = []
}