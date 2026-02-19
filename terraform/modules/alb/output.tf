
output "frontend_target_group" {
  value = aws_lb_target_group.frontend_target_group.arn
}
output "backend_target_group" {
  value = aws_lb_target_group.backend_target_group.arn
}
# Add this to outputs.tf to get the backend ALB DNS name
output "backend_alb_dns_name" {
  value = aws_lb.backend_alb.dns_name
}

output "frontend_alb_dns_name" {
  value = aws_lb.frontend_alb.dns_name
}
output "frontend_alb_zone_id" {
  value = aws_lb.frontend_alb.zone_id
}
