data "aws_ami" "latest_amazon_linux" {
    most_recent = true
    owners = ["amazon"]

     filter {
      name = "name"
      values =  ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_launch_template" "bny-launch-template" {
    name = "bny-${terraform.workspace}-launch-template"
    vpc_security_group_ids = [ var.aws_security_group_ec2 ]
    image_id = data.aws_ami.latest_amazon_linux.id
    instance_type = var.instance_type[var.environment]
    #key_name = "bny-keypair"
    user_data = base64encode(<<EOF
        #!/bin/bash
        sudo yum update -y
        sudo yum install -y httpd
        sudo systemctl enable httpd
        sudo systemctl start httpd
        echo "<h1>Hostname: $(hostname)</h1>" | sudo tee -a /var/www/html/index.html
      EOF
    )
    lifecycle {
        create_before_destroy = true
    }
    tag_specifications {
        resource_type = "instance"
        tags = {
            Name = "bny-${terraform.workspace}-instance"
        }
    }
    tags = {
        Name = "bny-${terraform.workspace}-launch-template"
    }
}

resource "aws_autoscaling_group" "bny-asg" {
    desired_capacity     = 2
    max_size             = 3
    min_size             = 2
    vpc_zone_identifier = [ var.aws_subnet_ids_public[0], var.aws_subnet_ids_public[1] ]
    launch_template {
        id      = aws_launch_template.bny-launch-template.id
        version = "$Latest"
    }
    target_group_arns = [var.target_group_arns]
    
    #health_check_type   = "ELB"
    #force_delete         = true
    #wait_for_capacity_timeout = "0"
      
}

resource "aws_lb_listener" "bny-lb-listener" {
    load_balancer_arn = var.aws_lb
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = var.target_group_arns
    }
}