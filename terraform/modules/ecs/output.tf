
output "backend_task_arn" {
  value = aws_ecs_task_definition.memos-backend.arn
}
output "frontend_task_arn" {
  value = aws_ecs_task_definition.memos-frontend.arn
}
