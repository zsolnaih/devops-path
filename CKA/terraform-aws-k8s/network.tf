#Define the VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name        = var.vpc_name
    Terraform   = "true"
  }
}

#Deploy the private subnets
resource "aws_subnet" "private_subnets" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnets[count.index]
  count = length(var.private_subnets)
  availability_zone_id = sort(data.aws_availability_zones.available.zone_ids)[count.index]

  tags = {
    Name = "k8s-private-${count.index + 1}"
  }
}

#Deploy the public subnets
resource "aws_subnet" "public_subnets" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnets[count.index]
  count = length(var.public_subnets)
  availability_zone_id = sort(data.aws_availability_zones.available.zone_ids)[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "k8s-public-${count.index + 1}"
  }
}

#Create route tables for public and private subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id     = aws_internet_gateway.internet_gateway.id
    #nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name      = "k8s_public_rtb"
    Terraform = "true"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = {
    Name      = "k8s_private_rtb"
    Terraform = "true"
  }
}

#Create route table associations
resource "aws_route_table_association" "public" {
  depends_on     = [aws_subnet.public_subnets]
  route_table_id = aws_route_table.public_route_table.id
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
}

resource "aws_route_table_association" "private" {
  depends_on     = [aws_subnet.private_subnets]
  route_table_id = aws_route_table.private_route_table.id
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
}

#Create Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "k8s_igw"
  }
}
