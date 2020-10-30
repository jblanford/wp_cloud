data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")

  vars = {
    project_name = var.project_name
    environment  = var.environment
  }
}

resource "aws_launch_configuration" "web_lc" {
  name_prefix   = "${var.project_name}-${var.environment}-lc-"
  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = var.web_server_instance_type
  user_data     = data.template_file.user_data.rendered

  security_groups             = [aws_security_group.web_server.id]
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

  desired_capacity  = var.asg_desired_capacity
  min_size          = var.asg_min_size
  max_size          = var.asg_max_size
  health_check_type = "ELB"

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
