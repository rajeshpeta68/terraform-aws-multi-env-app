variable "instance_type" {
    type = map(string) 
        default = {
          "default" = "t2.nano"
          "dev" = "t2.micro"
          "stage" = "t2.micro"
          "prod" = "t3.medium"
        }
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "aws_region" {
    type = map(string)
    default = {
        default = "ap-south-1"
        dev = "ap-south-1"
        stage = "us-east-1"
        prod = "us-east-2"
    }  
}

variable "aws_security_group_ec2" {
  type = string
}

variable "aws_subnet_ids_public" {
    type = list(string)  
}

variable "aws_lb_target_group" {
    type = map(string)
    default = {
        default = "bny-default-tg"
        dev = "bny-dev-tg"
        stage = "bny-stage-tg"
        prod = "bny-prod-tg"
    }  
}

variable "aws_targer_listener" {
    type = map(string)
    default = {
        default = "bny-default-listener"
        dev = "bny-dev-listener"
        stage = "bny-stage-listener"
        prod = "bny-prod-listener"
    }  
  
}

variable "target_group_arns" {
    type = string
}

variable "aws_lb" {
  type = string
}