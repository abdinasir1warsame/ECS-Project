output "rds_sg" {
  value = aws_security_group.rds-sg.id
}
output "frontend_alb_sg" {
  value = aws_security_group.frontend-alb-sg.id
}
output "backend_alb_sg" {
  value = aws_security_group.backend-alb-sg.id
}
output "frontend_task_sg" {
  value = aws_security_group.frontend-task-sg.id
}
output "backend_task_sg" {
  value = aws_security_group.backend-task-sg.id
}
