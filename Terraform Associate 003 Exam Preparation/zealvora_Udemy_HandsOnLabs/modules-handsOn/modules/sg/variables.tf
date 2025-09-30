variable "sg_name" {
    type = string
    default = "test-sg"
  
}

variable "regions" {
    type = set(string)
    default = null
}