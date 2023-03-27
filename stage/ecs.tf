resource "aws_ecs_cluster" "stage" {
  name = "stage-ecs"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}