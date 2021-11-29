

resource "aws_lb" "app" {
  name                             = local.nlb_name
  internal                         = "true"
  load_balancer_type               = "network"
  subnets                          = var.subnet_ids
  enable_cross_zone_load_balancing = true
  access_logs {
    bucket  = var.log_bucket_id
    prefix  = "nlb-${var.env}"
    enabled = true
  }
  tags = {
    Name        = local.nlb_name
    Owner       = local.owner
    Environment = var.env
  }
}
variable "app_port" {
  type = map(number)
  default = {
    tcp = 6005
  }
}




resource "aws_lb_listener" "app" {
  for_each          = var.app_port
  load_balancer_arn = aws_lb.app.arn

  protocol = "TCP"
  port     = each.value

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app[each.key].arn
  }

  tags = {
    Name        = local.nlb_listner_name
    Owner       = local.owner
    Environment = var.env
  }
}
resource "aws_lb_target_group" "app" {
  for_each = var.app_port

  port     = each.value
  protocol = "TCP"
  vpc_id   = var.vpc_id


  depends_on = [
    aws_lb.app
  ]

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name        = local.nlb_tg_name
    Owner       = local.owner
    Environment = var.env
  }
}

resource "aws_route53_record" "nlb" {
  zone_id = var.private_zone_id
  name    = local.nlb_name
  type    = "CNAME"
  ttl     = 60
  records = [aws_lb.app.dns_name]  ##records = [aws_lb.MYALB.dns_name]
}

output "app_route53_record" {
  value       = "${aws_route53_record.nlb.name}.${var.private_zone_name}"
  description = "NLB dns_name route53_record "
}