
#Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

#Define the VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = var.vpc_name
    Terraform   = "true"
  }
}

#Deploy the private subnets
resource "aws_subnet" "private_subnets" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

  tags = {
    Name      = each.key
    Terraform = "true"
  }
}

#Deploy the public subnets
resource "aws_subnet" "public_subnets" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value + 100)
  availability_zone       = tolist(data.aws_availability_zones.available.names)[each.value]
  map_public_ip_on_launch = true

  tags = {
    Name      = each.key
    Terraform = "true"
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
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
}

resource "aws_route_table_association" "private" {
  depends_on     = [aws_subnet.private_subnets]
  route_table_id = aws_route_table.private_route_table.id
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
}

#Create Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "k8s_igw"
  }
}


#################################################################
# Security groups
#################################################################
resource "aws_security_group" "cp" {
  name        = "controlpane_sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Terraform = "by zsolnaih"
  }
}

resource "aws_security_group" "node" {
  name        = "node_sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Terraform = "by zsolnaih"
  }
}


# Controlplane rules

resource "aws_vpc_security_group_egress_rule" "cp_egress" {
  security_group_id = aws_security_group.cp.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "cp_kubeapi_to_node" {
  security_group_id = aws_security_group.cp.id

  referenced_security_group_id = aws_security_group.node.id
  from_port   = 6443
  ip_protocol = "tcp"
  to_port     = 6443
}

resource "aws_vpc_security_group_ingress_rule" "cp_kubeapi" {
  security_group_id = aws_security_group.cp.id

  referenced_security_group_id = aws_security_group.cp.id
  from_port   = 10250
  ip_protocol = "tcp"
  to_port     = 10250
}

resource "aws_vpc_security_group_ingress_rule" "cp_kubescheduler" {
  security_group_id = aws_security_group.cp.id

  referenced_security_group_id = aws_security_group.cp.id
  from_port   = 10259
  ip_protocol = "tcp"
  to_port     = 10259
}

resource "aws_vpc_security_group_ingress_rule" "cp_kubecontroller" {
  security_group_id = aws_security_group.cp.id

  referenced_security_group_id = aws_security_group.cp.id
  from_port   = 10257
  ip_protocol = "tcp"
  to_port     = 10257
}


resource "aws_vpc_security_group_ingress_rule" "cp_allow_nodeport" {
  security_group_id = aws_security_group.cp.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 30000
  ip_protocol = "tcp"
  to_port     = 32767
}


resource "aws_vpc_security_group_ingress_rule" "cp_http" {
  security_group_id = aws_security_group.cp.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "cp_https" {
  security_group_id = aws_security_group.cp.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_ingress_rule" "cp_calico" {
  security_group_id = aws_security_group.cp.id

  referenced_security_group_id = aws_security_group.node.id
  from_port   = 179
  ip_protocol = "tcp"
  to_port     = 179
}

resource "aws_vpc_security_group_ingress_rule" "cp_calico_self" {
  security_group_id = aws_security_group.cp.id

  referenced_security_group_id = aws_security_group.cp.id
  from_port   = 179
  ip_protocol = "tcp"
  to_port     = 179
}

resource "aws_vpc_security_group_ingress_rule" "cp_calico_typha" {
  security_group_id = aws_security_group.cp.id

  referenced_security_group_id = aws_security_group.node.id
  from_port   = 5473
  ip_protocol = "tcp"
  to_port     = 5473
}

resource "aws_vpc_security_group_ingress_rule" "cp_calico_flow" {
  security_group_id = aws_security_group.cp.id

  referenced_security_group_id = aws_security_group.node.id
  from_port   = 7443
  ip_protocol = "tcp"
  to_port     = 7443
}

# Node rules
resource "aws_vpc_security_group_egress_rule" "node_egress" {
  security_group_id = aws_security_group.node.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "node_kubeapi" {
  security_group_id = aws_security_group.node.id

  referenced_security_group_id = aws_security_group.cp.id
  from_port   = 10250
  ip_protocol = "tcp"
  to_port     = 10250
}

resource "aws_vpc_security_group_ingress_rule" "node_allow_nodeport" {
  security_group_id = aws_security_group.node.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 30000
  ip_protocol = "tcp"
  to_port     = 32767
}

resource "aws_vpc_security_group_ingress_rule" "node_flannel" {
  security_group_id = aws_security_group.node.id

  referenced_security_group_id = aws_security_group.node.id
  from_port   = 8472
  ip_protocol = "udp"
  to_port     = 8472
}

resource "aws_vpc_security_group_ingress_rule" "node_calico" {
  security_group_id = aws_security_group.node.id

  referenced_security_group_id = aws_security_group.cp.id
  from_port   = 179
  ip_protocol = "tcp"
  to_port     = 179
}

resource "aws_vpc_security_group_ingress_rule" "node_calico_self" {
  security_group_id = aws_security_group.node.id

  referenced_security_group_id = aws_security_group.node.id
  from_port   = 179
  ip_protocol = "tcp"
  to_port     = 179
}

resource "aws_vpc_security_group_ingress_rule" "node_calico_typha" {
  security_group_id = aws_security_group.node.id

  referenced_security_group_id = aws_security_group.cp.id
  from_port   = 5473
  ip_protocol = "tcp"
  to_port     = 5473
}

resource "aws_vpc_security_group_ingress_rule" "node_calico_flow" {
  security_group_id = aws_security_group.node.id

  referenced_security_group_id = aws_security_group.cp.id
  from_port   = 7443
  ip_protocol = "tcp"
  to_port     = 7443
}


resource "aws_instance" "cp" {
  ami           = data.aws_ami.linux.id
  instance_type = "t3.small"
  subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id
  vpc_security_group_ids = [aws_security_group.cp.id]
  user_data_base64 = filebase64("./ec2-user-data-cp.sh")
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  tags = {
    Name = "k8s ControlPlane"
  }
  lifecycle {
    ignore_changes = [ ami ]
  }
}

resource "aws_instance" "node" {
  count                   = var.node_count
  ami                     = data.aws_ami.linux.id
  instance_type           = "t3.micro"
  subnet_id               = aws_subnet.public_subnets["public_subnet_1"].id
  user_data_base64        = filebase64("./ec2-user-data-node.sh")
  vpc_security_group_ids  = [aws_security_group.node.id]
  iam_instance_profile    = aws_iam_instance_profile.test_profile.name
  tags = {
    Name = "k8s node-${count.index+1}"
  }
  lifecycle {
    ignore_changes = [ ami ]
  }
}


resource "aws_iam_role" "ssm_k8s_role" {
  name = "test_role"

  assume_role_policy = jsonencode({
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})

}

resource "aws_iam_role_policy_attachment" "ssm_k8s_role_attach" {
  role       = aws_iam_role.ssm_k8s_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "ssm_k8s_profile"
  role = aws_iam_role.ssm_k8s_role.name
}

# Terraform Resource Block - To Build EC2 instance in Public Subnet
# resource "aws_instance" "web_server" {
#   ami           = data.aws_ami.linux.id
#   instance_type = "t3.micro"
#   subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id
#   tags = {
#     Name = "Linux EC2 Server"
#   }
# }

# output "ami_name" {
#   value = data.aws_ami.linux.name
# }

# data "aws_caller_identity" "me" {}

# output "whoami" {
#   value = data.aws_caller_identity.me
# }