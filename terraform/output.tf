output "backend_alb_dns_name" {
  description = "DNS name of the internal backend ALB"
  value       = module.alb.backend_alb_dns_name
}

output "frontend_alb_dns_name" {
  description = "DNS name of the public frontend ALB"
  value       = module.alb.frontend_alb_dns_name
}
output "application_url" {
  value = "https://memos-app-ecs.com"
}

