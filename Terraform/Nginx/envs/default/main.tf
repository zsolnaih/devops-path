
module "vpc" {
    source = "../../modules/vpc"
    vpc_cidr = var.vpc_cidr
    project_name = var.project_name
    private_subnets = var.private_subnets
    public_subnets = var.public_subnets
    single_nat = true
    nat_gw_needed = true
    
}

module "web" {
    source = "../../modules/web"
    private_subnets = module.vpc.private_subnets_ids
    public_subnets = module.vpc.public_subnets_ids
    project_name = var.project_name
    vpc_id = module.vpc.vpc_id
    depends_on = [ module.vpc ]
}