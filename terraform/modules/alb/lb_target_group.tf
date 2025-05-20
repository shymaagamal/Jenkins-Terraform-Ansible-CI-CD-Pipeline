resource "aws_lb_target_group" "alb_tg" {
  name     = "lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.alb_tg_vpc_id

}

