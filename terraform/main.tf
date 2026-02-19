module "vpc" {
  source             = "./modules/vpc"
  vpc_name           = "vpc_1"
  vpc_cidr           = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones = ["eu-west-2a", "eu-west-2b"]


}

terraform {
  required_version = ">= 1.10.0"
}
module "ecr" {
  source = "./modules/ecr"

}

module "security_groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id

}
module "rds" {
  source             = "./modules/rds"
  private_subnets_id = module.vpc.private_subnet_ids
  rds_sg             = module.security_groups.rds_sg
  db_name            = local.db_name
  username           = local.username
  password           = local.password
  port               = local.port

}
module "ecs_task" {
  source = "./modules/ecs"

  rds_db                 = module.rds.rds_db
  rds_port               = module.rds.rds_port
  rds_username           = module.rds.rds_username
  rds_password           = module.rds.rds_password
  rds_host               = module.rds.rds_host
  backend_repo_url       = module.ecr.backend_repo_url
  frontend_repo_url      = module.ecr.frontend_repo_url
  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
  backend_alb_dns_name   = module.alb.backend_alb_dns_name




}
module "ecs_service" {
  source               = "./modules/ecs-service"
  frontend_sg          = module.security_groups.frontend_task_sg
  backend_sg           = module.security_groups.backend_task_sg
  private_subnets_id   = module.vpc.private_subnet_ids
  vpc_id               = module.vpc.vpc_id
  cluster_id           = module.cluster.cluster_id
  backend_task_arn     = module.ecs_task.backend_task_arn
  frontend_task_arn    = module.ecs_task.frontend_task_arn
  ecs_execution_policy = module.iam.ecs_execution_role_arn
  ecs_service_role_arn = module.iam.ecs_service_role_arn
  frontend_alb_tg      = module.alb.frontend_target_group
  backend_alb_tg       = module.alb.backend_target_group



}
module "alb" {
  source = "./modules/alb"

  frontend_alb_sg = module.security_groups.frontend_alb_sg
  backend_alb_sg  = module.security_groups.backend_alb_sg
  public_subnets  = module.vpc.public_subnet_ids
  private_subnets = module.vpc.private_subnet_ids
  vpc_id          = module.vpc.vpc_id
  certificate_arn = module.route_53.certificate_arn

}
module "iam" {

  source = "./modules/iam"
}

module "cluster" {
  source = "./modules/ecs-cluster"
}

module "route_53" {
  source      = "./modules/route-53"
  alb_dns     = module.alb.frontend_alb_dns_name
  alb_zone_id = module.alb.frontend_alb_zone_id


}
