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
        default = "db.t3.micro"
        dev = "db.t3.micro"
        stage = "db.t3.small"
        prod = "db.t3.medium"
    }  
  
}

variable "aws_private_subnet_ids" {
    type = list(string)
  
}

variable "aws_security_group_rds" {
    type = string  
}
variable "db_username" {
    type = string
    default = "admin"  
}

variable "db_password" {
    type = string
    default = "admin1234" 
}