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

/*
module "ec2" {
  source = "./modules/ec2"
  aws_security_group_ec2 = module.vpc.aws_security_group_ec2
  aws_subnet_ids_public = module.vpc.aws_subnet_ids_public
  aws_region = var.aws_region
  target_group_arns = [module.lb.bny_tg_arn]
}
*/