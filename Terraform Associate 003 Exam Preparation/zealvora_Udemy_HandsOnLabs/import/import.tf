provider "aws" {
  region = "eu-central-1"
}

import {
  to = aws_s3_bucket.mybucket
  id = "henrik-terraform-backend"
}

import {
  to = aws_s3_bucket_policy.mybucket-policy
  id = "henrik-terraform-backend"
}