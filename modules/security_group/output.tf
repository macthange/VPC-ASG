

output "outbound-sg" {
  value = aws_security_group.outbound_sg.id
}


output "admin-sg" {
  value = aws_security_group.admin_sg.id
}

output "alb-sg" {
  value = aws_security_group.alb_sg.id
}

output "web-sg" {
  value = aws_security_group.web_sg.id
}


output "app-sg" {
  value = aws_security_group.app_sg.id
}


output "db_sg" {
  value = aws_security_group.db_sg.id
}




