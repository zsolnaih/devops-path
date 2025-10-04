variable "project_name" { 
    type = string 
}
variable "vpc_cidr" { 
    type = string 
}
variable "public_subnets" { 
    type = list(string) 
}
variable "private_subnets" { 
    type = list(string) 
}
variable "single_nat" { 
    type = bool 
    default = true

    validation {
      condition = var.single_nat == true || length(var.public_subnets) >= length(var.private_subnets)
      error_message = "In case of per-AZ NAT GW needed as many public subnets as private subnets"
    }
}
variable "nat_gw_needed" { 
    type = bool 
    default = false

    validation {
      condition = (var.nat_gw_needed == true && length(var.public_subnets) >= 1) || var.nat_gw_needed != true
      error_message = "At least 1 public subnet is needed"
    }
}