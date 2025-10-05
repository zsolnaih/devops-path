variable "project_name" { 
    description = "Name prefix for tags and resources"
    type = string 
}
variable "vpc_cidr" { 
    description = "VPC CIDR block"
    type = string 
}
variable "public_subnets" { 
    description = "Public subnet CIDRs"
    type = list(string) 
}
variable "private_subnets" { 
    description = "Private subnet CIDRs"
    type = list(string)
}
variable "single_nat" { 
    description = "Single NAT or per-AZ NAT GWs"
    type = bool 

    validation {
      condition = var.single_nat == true || length(var.public_subnets) >= length(var.private_subnets)
      error_message = "In case of per-AZ NAT GW needed as many public subnets as private subnets"
    }
}
