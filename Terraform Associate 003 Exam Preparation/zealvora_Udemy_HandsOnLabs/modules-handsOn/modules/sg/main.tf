resource "aws_security_group" "this" {
    name = var.sg_name
    provider = aws.prod    
  
}