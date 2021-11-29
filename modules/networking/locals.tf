locals {

  name             = "my-project"
  owner            = "my-Project@example.com"
  enabled          = "true"
  resource_count   = lookup(var.resource_count, var.env)
  region_number    = lookup(var.region_number, var.region)
  r53_private_zone = "my-project.${var.env}.aws.public.mycompany.net"
  r53_public_zone   =  "my-project.${var.env}.aws.public.mycompany.net"

}