resource "aws_ecs_cluster" "uat" {
  name = "uat-ecs"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}