variable "backend-prod" {
    default = {
        prod = {
            bucket = "henrik-terraform-backend"
            key = "tfstate/prod/terraform.tfstate"  
        }
        test = {
            bucket = "henrik-terraform-backend"
            key = "tfstate/test/terraform.tfstate"  
        }
    }
}

variable "env" {
    default = "prod"
}