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
        echo "<h1>Hello from ${terraform.workspace}!</h1>" > /var/www/html/index.html)
        echo "<h1>Hostname: $(hostname)</h1>" >> /var/www/html/index.html
      EOF
    )
    lifecycle {
        create_before_destroy = true
    }
    tags = {
        Name = "bny-${terraform.workspace}-launch-template"
    }
}

resource "aws_autoscaling_group" "bny-asg" {
    desired_capacity     = 1
    max_size             = 2
    min_size             = 1
    vpc_zone_identifier = [ var.aws_subnet_ids_public[0], var.aws_subnet_ids_public[1] ]
    launch_template {
        id      = aws_launch_template.bny-launch-template.id
        version = "$Latest"
    }
    target_group_arns = [var.target_group_arns]
    
    health_check_type   = "ELB"
    force_delete         = true
    wait_for_capacity_timeout = "0"
      
}
resource "aws_autoscaling_attachment" "bny-asg-attachment" {
    autoscaling_group_name = aws_autoscaling_group.bny-asg.name
    lb_target_group_arn   = var.aws_lb_target_group[var.environment]
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