variable "aws_region" {
    type = map(string)
    default = {
        default = "ap-south-1"
        dev = "ap-south-1"
        stage = "us-east-1"
        prod = "us-east-2"
    }  
}
