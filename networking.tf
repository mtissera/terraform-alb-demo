#############################################
# Virtual Private Cloud:
#############################################
resource "aws_vpc" "tf_vpc" {
  cidr_block           = var.tf_vpc
  instance_tenancy     = var.vpc_tenancy
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tf_alb_vpc"
  }
}

#############################################
# Public subnets:
#############################################

resource "aws_subnet" "public_subnet" {
  count             = var.instance_count
  vpc_id            = aws_vpc.tf_vpc.id
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  cidr_block        = element(cidrsubnets(var.tf_vpc, 8, 8, 8), count.index) #We use the cidrsubnet and element function to create the necessary CIDR Blocks

  tags = {
    "Name" = "TF-Public-Subnet-${count.index}"
  }
}

#############################################
# Internet Gateway:
#############################################

resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    "Name" = "TF-Internet-Gateway"
  }
}

#############################################
# Public Route Table:
#############################################
resource "aws_route_table" "tf_public_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    "Name" = "TF-Public-RouteTable"
  }
}

#############################################
# Public Route:
#############################################

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.tf_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tf_igw.id
}

#############################################
# Public Route Table Association:
#############################################

resource "aws_route_table_association" "public_rt_association" {
  count          = var.instance_count
  route_table_id = aws_route_table.tf_public_rt.id
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
}
