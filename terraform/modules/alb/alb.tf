resource "aws_lb" "alb_nginx" {
  name               = "Application-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_sg_id
  subnets            = var.alb_subnet_ids
  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.alb_nginx.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}