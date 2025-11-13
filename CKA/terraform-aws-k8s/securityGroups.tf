#Controlplane SG
resource "aws_security_group" "cp" {
  name        = "controlpane_sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Terraform = "by zsolnaih"
  }
}

#Node SG
resource "aws_security_group" "node" {
  name        = "node_sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Terraform = "by zsolnaih"
  }
}

#############################################
# Controlplane rules
#############################################
resource "aws_vpc_security_group_egress_rule" "cp_egress" {
  security_group_id = aws_security_group.cp.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "cp_kubeapi" {
  security_group_id = aws_security_group.cp.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 6443
  ip_protocol = "tcp"
  to_port     = 6443
}

resource "aws_vpc_security_group_ingress_rule" "cp_https_from_node" {
  security_group_id = aws_security_group.cp.id

  referenced_security_group_id = aws_security_group.node.id
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



#############################################
# Node rules
#############################################

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

resource "aws_vpc_security_group_ingress_rule" "node_calico" {
  security_group_id = aws_security_group.node.id

  referenced_security_group_id = aws_security_group.cp.id
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
