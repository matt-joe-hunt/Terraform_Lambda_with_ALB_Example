provider "aws" {
  region = var.region-master
}

module "ALB" {
  source = "./ALB"

  environment   = var.environment
  aws_sg = module.SG.aws_sg
  public_subnetA_id = module.VPC.public_subnetA_id
  public_subnetB_id = module.VPC.public_subnetB_id
}

module "Lambda" {
  source        = "./Lambda"
  region-master = var.region-master
  project       = var.project
  environment   = var.environment
  accountId     = var.accountId

  aws_lb_target_group_arn = module.ALB.aws_lb_target_group_arn
}

module "VPC" {
  source   = "./VPC"
  vpc-name = var.vpc-name
}

module "SG" {
  source  = "./SG"
  sg-name = var.sg-name
  vpc_id  = module.VPC.vpc_id
}