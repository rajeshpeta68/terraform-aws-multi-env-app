provider "aws" {
    region = var.aws_region[terraform.workspace]
}

module "vpc" {
  source = "./modules/vpc"
}

module "lb" {
  source = "./modules/lb"
  vpc_id = module.vpc.vpc_id
  aws_region = var.aws_region
  aws_security_group_alb = module.vpc.aws_security_group_alb
  aws_subnet_ids_public = module.vpc.aws_subnet_ids_public
  aws_internet_gateway = module.vpc.aws_internet_gateway
}

module "ec2" {
  source = "./modules/ec2"
  aws_security_group_ec2 = module.vpc.aws_security_group_ec2
  aws_subnet_ids_public = module.vpc.aws_subnet_ids_public
  aws_lb = module.lb.aws_lb
  target_group_arns = module.lb.aws_lb_target_group_arn
}

module "rds" {
  source = "./modules/rds"
  aws_private_subnet_ids = [module.vpc.aws_private_subnet_ids[0], module.vpc.aws_private_subnet_ids[1]]
  aws_security_group_rds = module.vpc.aws_security_group_rds
}