# Create an ALB to route traffic to the ECS service
resource "aws_lb" "fargate_alb" {
  name               = "${var.environment}-fargate-alb"
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.fargate_sg.id]
}

# Create a listener on the ALB to forward traffic to the ECS service
resource "aws_lb_listener" "fargate_alb_listener" {
  load_balancer_arn = aws_lb.fargate_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fargate_target_group.arn
  }
}

# Create a target group for the ECS service
resource "aws_lb_target_group" "fargate_target_group" {
  name     = "${var.environment}-fargate-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/health"
    port = "traffic-port"
  }
}

# Attach the ECS service to the target group
resource "aws_lb_target_group_attachment" "fargate_target_group_attachment" {
  target_group_arn = aws_lb_target_group.fargate_target_group.arn
  target_id        = aws_ecs_service.backend_service.id
  port             = 80
}
