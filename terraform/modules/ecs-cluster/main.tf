resource "aws_ecs_cluster" "memos_cluster" {
  name = "memos_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
