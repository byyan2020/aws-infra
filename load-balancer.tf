resource "aws_lb" "lb" {
  name               = "csye6225-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.load_balancer_sg.id]
  subnets = [for s in aws_subnet.public_subnets : s.id]
  tags = {
    Application = "WebApp"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "csye6225-lb-alb-tg"
  target_type = "instance"
  port = 8080
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id
  health_check {
    path="/healthz"
    protocol = "HTTP"
    matcher = 200
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }

}
