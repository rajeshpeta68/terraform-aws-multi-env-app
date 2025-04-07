output "aws_lb_target_group" {
  value = aws_lb_target_group.bny-tg.id 
}
output "aws_lb" {
  value = aws_lb.bny-lb.id 
}
output "bny_tg_arn" {
  value = aws_lb_target_group.bny-tg.arn
}

###############################################

