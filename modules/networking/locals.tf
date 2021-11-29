locals {

  name           = "my-project"
  owner          = "my-Project@example.com"
  enabled        = "true"
  resource_count = lookup(var.resource_count, var.env)
  region_number  = lookup(var.region_number, var.region)


}