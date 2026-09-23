ami_id = "ami-05f991c49d264708f"
asg_sizes = {
  min_size         = 1
  max_size         = 2
  desired_capacity = 1
}
key_pair = "staging-keypair"
common_tags = {
  "Project"   = "terraform-multi-env",
  "ManagedBy" = "terraform"
}
database_name           = "stagingdb"
database_username       = "dbadmin"
database_engine         = "postgres"
database_engine_version = "16.3"
database_instance_type  = "db.t3.small"
database_storage        = 30
public_subnets = {
  "public_1" = {
    cidr = "10.3.1.0/24"
    az   = "us-east-1a"
  }
  "public_2" = {
    cidr = "10.3.2.0/24"
    az   = "us-east-1b"
  }
}
private_subnets = {
  "private_1" = {
    cidr = "10.3.10.0/24"
    az   = "us-east-1a"
  }
  "private_2" = {
    cidr = "10.3.20.0/24"
    az   = "us-east-1b"
  }
}
allowed_ssh_cidr = "192.0.2.0/24"
vpc_cidr = "10.2.0.0/16"
environment      = "staging"
email = "onaefe6@gmail.com"
cpu_threshold = 70
retention_in_days = 30