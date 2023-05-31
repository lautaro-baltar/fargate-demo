# Create a security group for the Fargate cluster
resource "aws_security_group" "fargate_sg" {
  name        = "${var.environment}-fargate-sg"
  description = "Allow traffic into the Fargate Cluster"
  vpc_id      = var.vpc_id
}

# Allow HTTP traffic into the cluster
resource "aws_security_group_rule" "HTTP" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.fargate_sg.id
}