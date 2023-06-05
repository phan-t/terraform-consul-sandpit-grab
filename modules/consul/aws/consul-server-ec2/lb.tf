data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["${var.deployment_id}"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}

data "aws_security_group" "consul-ui-lb" {
  filter {
    name   = "tag:Name"
    values = ["${var.deployment_id}-consul-ui-lb"]
  }
}

resource "aws_lb_target_group" "consul-ui" {
  name     = "${var.deployment_id}-consul-ui"
  port     = 8501
  protocol = "HTTPS"
  vpc_id   = data.aws_vpc.this.id
}

resource "aws_lb_target_group_attachment" "consul-ui" {
  target_group_arn = aws_lb_target_group.consul-ui.arn
  target_id        = aws_instance.consul-server.id
  port             = 8501
}

resource "aws_lb" "consul-ui" {
  name               = "${var.deployment_id}-consul-ui"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.consul-ui-lb.id]
  subnets            = data.aws_subnets.public.ids

  tags = {
    Name  = "${var.deployment_id}-consul-server"
  }
}

resource "aws_lb_listener" "consul-ui" {
  load_balancer_arn = aws_lb.consul-ui.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_iam_server_certificate.ui.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.consul-ui.arn
  }
}