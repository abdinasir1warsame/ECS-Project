
output "rds_host" {
  description = "RDS instance hostname"
  value       = aws_db_instance.memos.address
  sensitive   = true
}
output "rds_db" {
  description = "RDS db name"
  value       = var.db_name
  sensitive   = true
}
output "rds_port" {
  description = "RDS instance port"
  value       = var.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = var.username
  sensitive   = true
}
output "rds_password" {
  description = "RDS instance password"
  value       = var.password
  sensitive   = true
}

