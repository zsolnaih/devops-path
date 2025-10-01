provider "aws" {
  region = "eu-central-1"
}

data "terraform_remote_state" "eip" {
    backend = "local"
    config = {
      path = "../tfstate/terraform.tfstate"
    }
  
}

resource "aws_security_group" "allow_tls" {
    name = "allow_tls"
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
    security_group_id = aws_security_group.allow_tls.id
    cidr_ipv4 = "${data.terraform_remote_state.eip.outputs.pub_ip_addr}/32"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
  
}