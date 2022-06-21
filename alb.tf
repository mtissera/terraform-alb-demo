###################################################
# Target Group Creation
####################################################

resource "aws_lb_target_group" "tf_tg" {
  name        = "TargetGroup"
  port        = 80
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.tf_vpc.id

  health_check {
    path = "/"
    port = 80
  }
}

####################################################
# Target Group Attachment 
####################################################

resource "aws_alb_target_group_attachment" "tgattachment" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.tf_tg.arn
  target_id        = element(aws_instance.instance.*.id, count.index)
}

####################################################
# Application Load balancer
####################################################

resource "aws_lb" "lb" {
  name               = "ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tf_alb_sg.id, ]
  subnets            = aws_subnet.public_subnet.*.id
}

####################################################
# Listener
####################################################

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf_tg.arn
  }
}

