variable "aws_region" {
    type = map(string)
    default = {
        default = "ap-south-1"
        dev = "ap-southeast-1"
        stage = "us-east-1"
        prod = "us-east-2"
    }  
}

variable "vpc_name" {
    type = map(string)
    default = {
        default = "bny-default-vpc"
        dev = "bny-dev-vpc"
        stage = "bny-stage-vpc"
        prod = "bny-prod-vpc"
    }  
}


