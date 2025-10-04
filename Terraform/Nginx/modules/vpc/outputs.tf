output "vpc_id" {
    value =  aws_vpc.vpc.id
}

output "public_subnets_ids" {
    value =  aws_subnet.public[*].id
}

output "private_subnets_ids" {
    value =  aws_subnet.private[*].id
}

# output "private_rt" {
#     value = aws_route_table.private
# }

# output "public_rt" {
#     value = aws_route_table.public  
# }