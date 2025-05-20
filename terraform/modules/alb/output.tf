output "albOUT_targetGroup_arn" {
    value = aws_lb_target_group.alb_tg.arn
  description = "this is arn of target group"
}