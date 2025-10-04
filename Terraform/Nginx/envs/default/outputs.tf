# output "vpc" {
#     value = module.vpc
# }

output "alb" {
    value = module.web.alb_dns
  
}