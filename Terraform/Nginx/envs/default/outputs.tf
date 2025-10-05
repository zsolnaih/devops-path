output "alb" {
    value = "http://${module.web.alb_dns}"
}