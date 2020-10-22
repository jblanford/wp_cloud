resource "aws_launch_configuration" "web_lc" {
  name_prefix     = "${var.project_name}-${var.environment}-lc-"
  image_id        = var.web_server_ami
  instance_type   = var.web_server_instance_type

  security_groups             = [aws_security_group.public-web_server.id]
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
  associate_public_ip_address = false

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name_prefix          = "${var.project_name}-${var.environment}-asg-"
  launch_configuration = aws_launch_configuration.web_lc.name
  vpc_zone_identifier  = module.vpc.private_subnets

  desired_capacity     = 3
  min_size             = 1
  max_size             = 9
  health_check_type    = "ELB"

  # Attach these servers to the web-80-tg target group on the web-alb
  target_group_arns = [aws_lb_target_group.web-80-tg.arn]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-web"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }
}
