resource "aws_ecs_cluster" "prod" {
  name = "prod-ecs"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}