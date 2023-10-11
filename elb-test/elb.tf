resource "aws_lb" "default" {
  load_balancer_type = "application"
  name               = "${var.prefix}-alb"

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
  name     = "${var.prefix}-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.default.id
}

resource "aws_lb_target_group_attachment" "default" {
  count            = 2
  target_group_arn = aws_lb_target_group.default.arn
  target_id        = aws_instance.default[count.index].id
  port             = 80
}