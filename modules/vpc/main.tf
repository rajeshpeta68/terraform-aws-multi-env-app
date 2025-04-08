provider "aws" {
    region = var.aws_region[terraform.workspace]
}

data "aws_availability_zones" "available" {
   state = "available"
}

resource "aws_vpc" "bny" {
    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "bny-${terraform.workspace}-vpc"
    }
  
}

resource "aws_subnet" "bnypublicsubnetA" {
    cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.bny.id
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[0]

    tags = {
      Name = "bny-${terraform.workspace}-publicsubnetA"
    }  
}

resource "aws_subnet" "bnypublicsubnetB" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.bny.id
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[1]

    tags = {
      Name = "bny-${terraform.workspace}-publicsubnetB"
    }  
}

resource "aws_subnet" "bnyprivatesubnetA" {
    cidr_block = "10.0.3.0/24"
    vpc_id = aws_vpc.bny.id

    tags = {
      Name = "bny-${terraform.workspace}-privatesubnetA"
    }
  
}

resource "aws_internet_gateway" "bny-igw" {
    vpc_id = aws_vpc.bny.id

    tags = {
      Name = "bny-igw-${terraform.workspace}"
    }
}

resource "aws_eip" "nateip" {
    #vpc = true

    depends_on = [ aws_internet_gateway.bny-igw ]
  tags = {
    Name = "bny-nateip-${terraform.workspace}"
  }
}

resource "aws_nat_gateway" "bny-natgw" {
    subnet_id = aws_subnet.bnypublicsubnetA.id
    allocation_id = aws_eip.nateip.id

    depends_on = [ aws_internet_gateway.bny-igw ]

    tags = {
      Name = "bny-nategw-${terraform.workspace}"
    }
}

resource "aws_security_group" "bnysg-ec2" {
  vpc_id      = aws_vpc.bny.id
  name        = "bny-${terraform.workspace}-sg-ec2"
  description = "Security group for EC2 instances"

  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  ingress {
    description      = "Allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    #cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = []
    security_groups = [aws_security_group.bnysg-alb.id]
  }

  egress {
    description      = "Allow all egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
}

resource "aws_security_group" "bnysg-alb" {
  vpc_id      = aws_vpc.bny.id
  name        = "bny-${terraform.workspace}-sg-alb"
  description = "Security group for ALB"

  ingress {
    description      = "Allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = []
  }

  egress {
    description      = "Allow all egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = []
  }
}


resource "aws_route_table" "bny-public-routeA" {
  vpc_id = aws_vpc.bny.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bny-igw.id
  }
  tags = {
    Name = "bny-${terraform.workspace}-public-routeA"
  }
  
}

resource "aws_route_table" "bny-public-routeB" {
  vpc_id = aws_vpc.bny.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bny-igw.id
  }
  tags = {
    Name = "bny-${terraform.workspace}-public-routeB"
  }
  
}

resource "aws_route_table_association" "bny-public-routeA-connection" {
  subnet_id      = aws_subnet.bnypublicsubnetA.id
  route_table_id = aws_route_table.bny-public-routeA.id  
}