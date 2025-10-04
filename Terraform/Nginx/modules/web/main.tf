data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*kernel-6.1-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}


resource "aws_security_group" "ec2_web" {
  name        = "web_server_sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-web_server_sg"
    Terraform = "by zsolnaih"
    Project = var.project_name
  }
}

resource "aws_security_group" "alb" {
  name        = "alb_sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-alb_sg"
    Terraform = "by zsolnaih"
    Project = var.project_name
  }
}

resource "aws_lb" "web" {
  name               = "web-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnets

  tags = {
    Name = "${var.project_name}-alb"
    Terraform = "by zsolnaih"
    Project = var.project_name
  }
}

resource "aws_lb_target_group" "web" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  deregistration_delay = 30
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_launch_template" "web_launch_template" {
    name = "web_server_launch_template"
    image_id = data.aws_ami.linux.id
    vpc_security_group_ids = [aws_security_group.ec2_web.id]
    user_data = filebase64("${path.module}/ec2-user-data.sh")
    instance_type = var.instance_type
    tags = {
        Name = "${var.project_name}-web_server_launch_template"
        Terraform = "by zsolnaih"
        Project = var.project_name
    }

}

resource "aws_autoscaling_group" "web" {
  vpc_zone_identifier = var.private_subnets
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  name = "ASG for Nginx"
  health_check_type = "ELB"
  health_check_grace_period = 90
  force_delete = true

  launch_template {
    id      = aws_launch_template.web_launch_template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.web.arn]
}

resource "aws_vpc_security_group_ingress_rule" "alb_ingress" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "-1"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "web_ingress" {
  security_group_id = aws_security_group.ec2_web.id

  referenced_security_group_id = aws_security_group.alb.id
  from_port   = 80
  ip_protocol = "-1"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "web_egress" {
  security_group_id = aws_security_group.ec2_web.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}