#####################################################
# VPC Variables
#####################################################

variable "tf_vpc" {
  description = "VPC for terraform-alb-demo"
  type        = string
  default     = "10.10.0.0/16"
}

variable "vpc_tenancy" {
  description = "Defines the tenancy of VPC. Whether it's default or dedicated"
  type        = string
  default     = "default"
}

#####################################################
# EC2 Variables
#####################################################

variable "instance_count" {
  default = "2"
}

variable "ami_id" {
  description = "ami id"
  type        = string
  default     = "ami-08d4ac5b634553e16" # Ubuntu Server 20.04 LTS (HVM)
}

variable "instance_type" {
  description = "Instance type to create an instance"
  type        = string
  default     = "t2.micro" # To stay within the AWS free-tier 
}

variable "instance_userdata" {
  type    = list(any)
  default = ["userdata-docker-nginx.sh", "userdata-docker-apache.sh"] # Just because we choose different cointainer for our instances
}