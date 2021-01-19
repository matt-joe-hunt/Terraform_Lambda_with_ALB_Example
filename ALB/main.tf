resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.aws_sg]
  subnets            = [var.public_subnetA_id, var.public_subnetB_id]

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lambda.arn
  }
}

resource "aws_lb_target_group" "lambda" {
  name        = "tf-example-lb-tg"
  target_type = "lambda"
}