# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "henrik-terraform-backend"
resource "aws_s3_bucket_policy" "mybucket-policy" {
  bucket = "henrik-terraform-backend"
  policy = file("./bucket_policy.json")
  region = "eu-central-1"
}

# __generated__ by Terraform from "henrik-terraform-backend"
resource "aws_s3_bucket" "mybucket" {
  bucket              = "henrik-terraform-backend"
  bucket_prefix       = null
  force_destroy       = false
  object_lock_enabled = false
  region              = "eu-central-1"
  tags                = {}
  tags_all            = {}
}
