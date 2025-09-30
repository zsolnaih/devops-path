# provider "aws" {
#     region = "eu-central-1"
# }

# provider "aws" {
#     alias = "us_east"
#     region = "us-east-1"
# }

# module "ec2" {
#     source = "../modules/ec2"
#     instance_type = "m5.large"
# }

# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"
# }

# module "sg" {
#     source = "../modules/sg"
#     providers = {
#       aws.prod = aws.us_east
#     }

# }

# output "ec2_pub_ip" {
#     value = module.ec2.ec2_details.public_ip
# }