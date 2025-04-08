provider "aws" {
    region = var.aws_region[terraform.workspace]  
}

resource "aws_db_subnet_group" "bny_db_subnet_group" {
    name       = "bny-${terraform.workspace}-db-subnet-group"
    subnet_ids = var.aws_private_subnet_ids
    tags = {
        Name = "bny-${terraform.workspace}-db-subnet-group"
    }
  
}

resource "aws_db_instance" "bny_db" {
    #name                 = "bny-${terraform.workspace}-db"
    engine              = "mysql"
    engine_version      = "8.0"
    instance_class      = var.instance_class[terraform.workspace]
    allocated_storage    = 20
    storage_type        = "gp2"
    username            = var.db_username
    password            = var.db_password
    db_subnet_group_name = aws_db_subnet_group.bny_db_subnet_group.name
    vpc_security_group_ids = [var.aws_security_group_rds]
    skip_final_snapshot = true
   
    tags = {
        Name = "bny-${terraform.workspace}-db"
    }
  
}