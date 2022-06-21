locals {
  ingress_rules = [{
    name        = "HTTP"
    port        = 80
    description = "Ingress rule for port 80"
    },
    {
      name        = "SSH"
      port        = 22
      description = "Ingress rule for port 22" #only for testing purposes
  }]

}

resource "aws_security_group" "tf_alb_sg" {

  name        = "tf_alb_sg"
  description = "Allow http inbound traffic & all outgoing traffic"
  vpc_id      = aws_vpc.tf_vpc.id
  egress = [
    {
      description      = "all outgoing traffic (no limitation)"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = {
    Name = "AWS security group dynamic block"
  }

}