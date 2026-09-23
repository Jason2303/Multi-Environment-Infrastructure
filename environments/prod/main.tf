module "networking" {
  source = "../../modules/networking"

  vpc_cidr           = var.vpc_cidr
  environment        = var.environment
  common_tags        = var.common_tags
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  single_nat_gateway = var.single_nat_gateway
}

module "compute" {
  source = "../../modules/compute"

  vpc_id            = module.networking.vpc_id
  private_subnet_id = values(module.networking.private_subnet)
  instance_type     = var.instance_type
  ami_id            = var.ami_id
  key_pair          = var.key_pair
  asg_sizes         = var.asg_sizes
  allowed_ssh_cidr  = var.allowed_ssh_cidr
  environment       = var.environment
  common_tags       = var.common_tags


}

module "database" {
  source = "../../modules/database"

  vpc_id                    = module.networking.vpc_id
  private_subnet_id         = values(module.networking.private_subnet)
  compute_security_group_id = module.compute.security_group_id
  database_name             = var.database_name
  database_username         = var.database_username
  database_password         = var.database_password
  database_engine           = var.database_engine
  database_engine_version   = var.database_engine_version
  database_instance_type    = var.database_instance_type
  database_storage          = var.database_storage
  environment               = var.environment
  common_tags               = var.common_tags
  multi_az                  = var.multi_az
}

module "monitoring" {
  source = "../../modules/monitoring"
  environment = var.environment
  common_tags = var.common_tags
  email = var.email
  asg_name = module.compute.autoscaling_group_name
  cpu_threshold = var.cpu_threshold
  retention_in_days = var.retention_in_days
}