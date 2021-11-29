resource "aws_launch_template" "app_lt" {

  name        = var.type ? null : local.nlb_lt_name
  name_prefix = var.type ? "${local.nlb_lt_name}-" : null


  ebs_optimized = true
  image_id      = var.image_id
  instance_type = var.instance_type
  iam_instance_profile {
    name = aws_iam_role.asg.name
  }
  #key_name      = var.key_name
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }
  vpc_security_group_ids = var.security_group
  user_data              = var.user_data

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "app" {
  name                = local.nlb_asg_name
  capacity_rebalance  = true
  desired_capacity    = 12
  max_size            = 15
  min_size            = 12
  vpc_zone_identifier = var.subnet_ids

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  warm_pool {
    pool_state                  = "Stopped"
    min_size                    = 1
    max_group_prepared_capacity = 10
  }

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 1
      on_demand_percentage_above_base_capacity = 25
      spot_allocation_strategy                 = "capacity-optimized"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.app_lt.id
      }


      override {
        instance_type     = "c4.large"
        weighted_capacity = "3"
      }

      override {
        instance_type     = "c3.large"
        weighted_capacity = "2"
      }

    }
  }
}

resource "aws_autoscaling_policy" "app_policy_up" {
  name                   = "app_policy_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app.name
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_alarm_up" {
  alarm_name          = "app_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.app_policy_up.arn]
}
resource "aws_autoscaling_policy" "app_policy_down" {
  name                   = "app_policy_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app.name
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_alarm_down" {
  alarm_name          = "app_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.app_policy_down.arn]
}

resource "aws_autoscaling_attachment" "target" {
  for_each = var.app_port

  autoscaling_group_name = aws_autoscaling_group.app.name
  alb_target_group_arn   = aws_lb_target_group.app[each.key].arn
}