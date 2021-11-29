output "app_route53_record" {
  value       = module.app_srv.app_route53_record
  description = "NLB dns_name route53_record "
}

output "web_route53_record" {
  value       = module.web_srv.web_route53_record
  description = "RDS enpoint route53_record "
}

output "rds_route53_record" {
  value       = module.pg_rds.rds_route53_record
  description = "RDS enpoint route53_record "
}

