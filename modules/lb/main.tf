provider "aws" {
    region = var.aws_region[terraform.workspace] 
}

resource "aws_lb_target_group" "bny-tg" {
    name     = "bny-${terraform.workspace}-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id
    target_type = "instance"

    health_check {
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 5
        interval            = 30
        path                = "/index.html"
        protocol            = "HTTP"
        matcher             = "200"
    }

    tags = {
        Name = "bny-${terraform.workspace}-tg"
    }
  
}

resource "aws_lb" "bny-lb" {
    name               = "bny-${terraform.workspace}-lb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [var.aws_security_group_alb]
    subnets            = var.aws_subnet_ids_public

    depends_on = [ var.aws_internet_gateway ]

    enable_deletion_protection = false

    enable_http2 = true
    enable_cross_zone_load_balancing = true


    tags = {
        Name = "bny-${terraform.workspace}-lb"
    }
  
}