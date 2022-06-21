####################################################################
# EC2 Instances:
####################################################################

resource "aws_instance" "instance" {
  count           = var.instance_count
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = element(aws_subnet.public_subnet.*.id, count.index)
  security_groups = [aws_security_group.tf_alb_sg.id, ]
  #iam_instance_profile = data.aws_iam_role.iam_role.name
  associate_public_ip_address = true
  #key_name             = "ubuntu-aws-test"

  tags = {
    "Name"        = "Instance-${count.index}"
    "Environment" = "Test-ALB"
    "CreatedBy"   = "Terraform"
  }

  timeouts {
    create = "10m"
  }

  user_data = file(element(var.instance_userdata, count.index))

}
