variable "frontend_sg" {
  type = string
}
variable "backend_sg" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "private_subnets_id" {
  type = list(any)
}
variable "cluster_id" {
  type = string
}
variable "backend_task_arn" {
  type = string
}
variable "frontend_task_arn" {
  type = string
}
variable "ecs_execution_policy" {
  type = string
}
variable "frontend_alb_tg" {
  type = string
}
variable "backend_alb_tg" {
  type = string
}
variable "ecs_service_role_arn" {
  type = string
}
