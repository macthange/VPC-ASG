

resource "aws_lb" "web" {

  name                             = local.alb_name
  internal                         = "false"
  load_balancer_type               = "application"
  enable_cross_zone_load_balancing = true
  enable_http2                     = true
  idle_timeout                     = var.idle_timeout
  ip_address_type                  = var.ip_address_type
  enable_deletion_protection       = var.deletion_protection_enabled
  drop_invalid_header_fields       = var.drop_invalid_header_fields

  access_logs {
    bucket  = var.log_bucket_id
    prefix  = "alb-${var.env}"
    enabled = true
  }
  subnets         = var.subnet_ids
  security_groups = var.alb_security_group

  tags = {
    Name        = local.alb_name
    Owner       = local.owner
    Environment = var.env
  }
}
variable "web_ports" {
  type = map(number)
  default = {
    https : 443
  }
}




resource "aws_lb_listener" "web" {
  for_each          = var.web_ports
  load_balancer_arn = aws_lb.web.arn

  protocol = "https"
  port     = each.value
  #ssl_policy        = var.https_ssl_policy
  #certificate_arn = var.certificate_arn

  default_action {
    target_group_arn = var.listener_https_fixed_response != null ? null : aws_lb_target_group.web[each.key].arn
    type             = var.listener_https_fixed_response != null ? "fixed-response" : "forward"

    dynamic "fixed_response" {
      for_each = var.listener_https_fixed_response != null ? [var.listener_https_fixed_response] : []
      content {
        content_type = fixed_response.value["content_type"]
        message_body = fixed_response.value["message_body"]
        status_code  = fixed_response.value["status_code"]
      }
    }
  }

  tags = {
    Name        = local.alb_listner_name
    Owner       = local.owner
    Environment = var.env
  }
}
resource "aws_lb_target_group" "web" {
  for_each = var.web_ports

  name                 = local.alb_tg_name
  port                 = each.value
  protocol             = "https"
  vpc_id               = var.vpc_id
  target_type          = var.target_group_target_type
  deregistration_delay = var.deregistration_delay
  health_check {
    protocol            = "https"
    path                = var.health_check_path
    port                = each.value
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
  }

  depends_on = [
    aws_lb.web
  ]

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name        = local.alb_tg_name
    Owner       = local.owner
    Environment = var.env
  }
}

resource "aws_autoscaling_attachment" "target" {
  for_each = var.web_ports

  autoscaling_group_name = aws_lb.web.name
  alb_target_group_arn   = aws_lb_target_group.web[each.key].arn
}

#resource "aws_lb_listener_certificate" "https_sni" {
#  for_each = var.web_ports  
#  listener_arn    = aws_lb_target_group.web[each.key].arn
#  certificate_arn = var.additional_certs[count.index]
#}

resource "aws_route53_record" "alb" {
  zone_id = var.public_zone_id
  name    = local.alb_name
  type    = "CNAME"
  ttl     = 60
  records = [aws_lb.web.dns_name]  ##records = [aws_lb.MYALB.dns_name]
}

output "web_route53_record" {
  value       = "${aws_route53_record.alb.name}.${var.public_zone_name}"
  description = "ALB dns_name route53_record "
}