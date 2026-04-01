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

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "memos-app-ecs.com"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "production"
    Project     = "memos-app"
  }
}
