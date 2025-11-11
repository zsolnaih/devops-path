
module "vpc" {
    source = "../../modules/vpc"
    vpc_cidr = var.vpc_cidr
    project_name = var.project_name
    private_subnets = var.private_subnets
    public_subnets = var.public_subnets
    single_nat = var.single_nat  
}

# module "web" {
#     source = "../../modules/web"
#     private_subnets = module.vpc.private_subnets_ids
#     public_subnets = module.vpc.public_subnets_ids
#     project_name = var.project_name
#     vpc_id = module.vpc.vpc_id
#     desired_capacity = var.desired_capacity
#     min_size = var.min_size
#     max_size = var.max_size
#     instance_type = var.instance_type
#     ssm_managed = var.ssm_managed
#     allowed_http_cidrs = var.allowed_http_cidrs

#     depends_on = [ module.vpc ]
# }

