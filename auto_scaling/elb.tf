resource "aws_lb" "default" {
  name               = "${var.prefix}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.default.id]
  subnets         = [aws_subnet.public[0].id, aws_subnet.public[1].id]

}

resource "aws_lb_listener" "default" {
  load_balancer_arn = aws_lb.default.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}

resource "aws_lb_target_group" "default" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.default.id

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    healthy_threshold   = 2
    interval            = 30
    protocol            = "HTTP"
    unhealthy_threshold = 2
  }

  depends_on = [
    aws_lb.default
  ]

  lifecycle {
    create_before_destroy = true
  }
}
