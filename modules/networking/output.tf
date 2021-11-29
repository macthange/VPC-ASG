
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets_id" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnets_id" {
  value = aws_subnet.private_subnet.*.id
}


output "database_subnet_id" {
  value = aws_subnet.database_subnet.*.id
}

output "rds_subnet_group" {
  value = aws_db_subnet_group.rds_subnet.*.id
}

output "rds_subnet_group_name" {
  value = aws_db_subnet_group.rds_subnet.*.name
}

output "public_zone_name" {
  value = aws_route53_zone.public.id
}
output "public_zone_id" {
  value = aws_route53_zone.public.id
}
output "private_zone_name" {
  value = aws_route53_zone.private.name
}
output "private_zone_id" {
  value = aws_route53_zone.private.id
}

