# ======================================
# FRONTEND ECS TASK DEFINITION
# ======================================
resource "aws_ecs_task_definition" "memos-frontend" {
  family                   = "memos-frontend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = null

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = var.frontend_repo_url
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        { containerPort = 8080 }
      ]
      # ADD ENVIRONMENT VARIABLES HERE
      environment = [
        {
          name  = "BACKEND_API_URL"
          value = "http://${var.backend_alb_dns_name}"
        },
        # Add any other frontend config variables
        {
          name  = "NODE_ENV"
          value = "production"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-region"        = "eu-west-2"
          "awslogs-group"         = "/ecs/ecs_test_frontend"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# ======================================
# BACKEND ECS TASK DEFINITION
# ======================================
resource "aws_ecs_task_definition" "memos-backend" {
  family                   = "memos-backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = null

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "${var.backend_repo_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        { containerPort = 8081 }
      ]
      environment = [
        { name = "MEMOS_DRIVER", value = "postgres" },
        { name = "MEMOS_MODE", value = "prod" },
        { name = "MEMOS_PORT", value = "8081" },
        { name = "MEMOS_DSN", value = "postgres://${var.rds_username}:${var.rds_password}@${var.rds_host}:${var.rds_port}/${var.rds_db}?sslmode=require" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-region"        = "eu-west-2"
          "awslogs-group"         = "/ecs/ecs_test_backend"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# ======================================
# CLOUDWATCH LOG GROUPS
# ======================================
resource "aws_cloudwatch_log_group" "frontend_logs" {
  name              = "/ecs/ecs_test_frontend"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "backend_logs" {
  name              = "/ecs/ecs_test_backend"
  retention_in_days = 7
}
