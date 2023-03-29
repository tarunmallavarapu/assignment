resource "aws_lb" "prod_ecs_lb" {
  name               = "prod-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [
    aws_security_group.prod-sgs.id
  ]
  subnets            = aws_subnet.public.*.id

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "prod_ecs_tg" {
  name     = "http1"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    port     = 5000
    protocol = "HTTP"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "prod_ecs_http" {
  load_balancer_arn = aws_lb.prod_ecs_lb.id
  port              = "5000"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.prod_ecs_tg.id
    type             = "forward"
  }
}

resource "aws_ecs_cluster" "prod" {
  name = "prod-ecs"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}


resource "aws_ecs_task_definition" "prod_ecs_task" {
  family                   = "prod-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = <<DEFINITION
[
  {
    "image": "312645443725.dkr.ecr.ap-northeast-2.amazonaws.com/test:latest",
    "cpu": 1024,
    "memory": 2048,
    "name": "test",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 5000,
        "hostPort": 5000
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "prod-service" {
  name            = "prod-service"
  cluster         = aws_ecs_cluster.prod.id
  task_definition = aws_ecs_task_definition.prod_ecs_task.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.prod-sgs.id]
    subnets         = aws_subnet.app.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.prod_ecs_tg.id
    container_name   = "test"
    container_port   = 5000
  }

  depends_on = [aws_lb_listener.prod_ecs_http]
}