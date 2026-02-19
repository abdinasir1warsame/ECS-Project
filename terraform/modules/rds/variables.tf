variable "private_subnets_id" {
  type = list(any)
}
variable "db_name" {
  type = string
}
variable "username" {
  type = string
}
variable "port" {
  type = number
}
variable "password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
}
variable "rds_sg" {
  type = string
}

