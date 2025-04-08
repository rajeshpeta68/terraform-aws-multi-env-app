variable "aws_region" {
    type = map(string)
    default = {
        default = "ap-south-1"
        dev = "ap-southeast-1"
        stage = "us-east-1"
        prod = "us-east-2"
    }  
}

variable "instance_class" {
    type = map(string)
    default = {
        default = ""
        dev = ""
        stage = "db.t3.small"
        prod = "db.t3.medium"
    }  
  
}

variable "aws_private_subnet_ids" {
    type = list(string)
  
}