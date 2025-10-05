#################################################################
# Datas and locals
#################################################################
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
    sorted_az_ids = sort(data.aws_availability_zones.available.zone_ids)
    nat_gw_count = var.single_nat ? 1 : length(var.private_subnets)
}

#################################################################
# VPC and Subnets
#################################################################
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.project_name}-vpc"
    Terraform = "by zsolnaih"
    Project = var.project_name
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnets[count.index]
  count = length(var.private_subnets)
  availability_zone_id = local.sorted_az_ids[count.index]

  tags = {
    Name = "${var.project_name}-private-${count.index + 1}"
    Terraform = "by zsolnaih"
    Project = var.project_name
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnets[count.index]
  count = length(var.public_subnets)
  availability_zone_id = local.sorted_az_ids[count.index]

  tags = {
    Name = "${var.project_name}-public-${count.index + 1}"
    Terraform = "by zsolnaih"
    Project = "${var.project_name}"
  }
}

#################################################################
# igw and NAT GW
#################################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
    Terraform = "by zsolnaih"
    Project = var.project_name
  }
}

resource "aws_eip" "eip" {
    count = local.nat_gw_count
    domain   = "vpc"

    tags = {
        Terraform = "by zsolnaih"
        Project = var.project_name
    }
}

resource "aws_nat_gateway" "nat_gw" {
    count = local.nat_gw_count
    allocation_id = aws_eip.eip[count.index].id
    subnet_id     = aws_subnet.public[count.index].id

    tags = {
        Name = "${var.project_name}-nat-gw-${count.index + 1}"
        Terraform = "by zsolnaih"
        Project = var.project_name
    }
    # To ensure proper ordering, it is recommended to add an explicit dependency
    # on the Internet Gateway for the VPC.
    depends_on = [aws_internet_gateway.igw]
}

#################################################################
# Route tables
#################################################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-rt-public"
    Terraform = "by zsolnaih"
    Project = var.project_name
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  count = local.nat_gw_count

  tags = {
    Name = "${var.project_name}-rt-private-${count.index + 1}"
    Terraform = "by zsolnaih"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = var.single_nat ? aws_route_table.private[0].id : aws_route_table.private[count.index].id
}

resource "aws_route" "igw_route" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route" "nat_gw_route" {
  count = local.nat_gw_count
  route_table_id            = aws_route_table.private[count.index].id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
}