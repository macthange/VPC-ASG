
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
/*
aws_subnet" "database_subnet"
output "default_sg_id" {
  value = "${aws_security_group.default.id}"
}

output "security_groups_ids" {
  value = ["${aws_security_group.default.id}"]
}

output "public_route_table" {
  value = "${aws_route_table.public.id}"
}
*/