
variable "rds_db" {
  type      = string
  sensitive = true
}
variable "rds_username" {
  type      = string
  sensitive = true
}
variable "rds_port" {
  type      = number
  sensitive = true
}
variable "rds_password" {
  type      = string
  sensitive = true
}
variable "rds_host" {
  type = string
}
variable "backend_repo_url" {
  type = string
}
variable "frontend_repo_url" {
  type = string
}

variable "ecs_execution_role_arn" {
  type = string
}
variable "backend_alb_dns_name" {
  type = string
}
