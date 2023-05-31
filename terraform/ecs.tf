# Create the Fargate cluster
resource "aws_ecs_cluster" "fargate_cluster" {
  name = "${var.environment}-fargate-cluster"
}

# Create a task definition
resource "aws_ecs_task_definition" "backend_task" {
  family                   = "backend-${var.environment}"
  execution_role_arn       = data.aws_iam_role.labRole.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = <<EOF
[
  {
    "name": "backend",
    "image": "${var.backend_image}",
    "portMappings": [
      {
        "containerPort": 8000,
        "protocol": "tcp"
      }
    ],
    "secrets": [
      {
        "name": "MONGO_URI",
        "valueFrom": "${var.backend_secret}"
      }
    ]
  }
]
EOF
}

# Create a service for the task definition
resource "aws_ecs_service" "backend_service" {
  name            = "backend-${var.environment}"
  cluster         = aws_ecs_cluster.fargate_cluster.id
  task_definition = aws_ecs_task_definition.backend_task.arn
  desired_count   = var.backend_desired_count
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.fargate_sg.id]
  }
}

# Create an Application Auto Scaling target
resource "aws_appautoscaling_target" "fargate_scaling_target" {
  max_capacity       = 5  # Maximum desired capacity
  min_capacity       = 1   # Minimum desired capacity
  resource_id        = aws_ecs_service.backend_service.id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Create an Application Auto Scaling policy
resource "aws_appautoscaling_policy" "fargate_scaling_policy" {
  name               = "${var.environment}-fargate-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.fargate_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.fargate_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.fargate_scaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
    }
    target_value = var.backend_scaling_target
  }
}