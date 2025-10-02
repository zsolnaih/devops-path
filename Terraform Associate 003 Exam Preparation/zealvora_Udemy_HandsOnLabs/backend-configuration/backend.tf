terraform {
    backend "s3" {
        bucket = "henrik-terraform-backend"
        key = "tfstate/prod/terraform.tfstate" 
        region = "eu-central-1"
        use_lockfile = true

    }

 #   backend "local" {
#     path = "D:\\GIT_Repos\\tf_backend\\terraform.tfstate"
#   }
}