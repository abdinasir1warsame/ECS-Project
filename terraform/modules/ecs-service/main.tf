resource "aws_ecs_service" "frontend" {
  name            = "frontend"
  cluster         = var.cluster_id
  task_definition = var.frontend_task_arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.frontend_alb_tg
    container_name   = "frontend"
    container_port   = 8080
  }

  network_configuration {
    subnets          = var.private_subnets_id
    security_groups  = [var.frontend_sg]
    assign_public_ip = false
  }
}


# BACKEND SERVICE 
resource "aws_ecs_service" "backend" {
  name            = "backend"
  cluster         = var.cluster_id
  task_definition = var.backend_task_arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.backend_alb_tg
    container_name   = "backend"
    container_port   = 8081
  }

  network_configuration {
    subnets          = var.private_subnets_id
    security_groups  = [var.backend_sg]
    assign_public_ip = false
  }
}


