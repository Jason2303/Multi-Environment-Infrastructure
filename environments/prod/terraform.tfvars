ami_id = "ami-05f991c49d264708f"
asg_sizes = {
  min_size         = 1
  max_size         = 5
  desired_capacity = 3
}
key_pair = "prod-keypair"
common_tags = {
  "Project"   = "terraform-multi-env",
  "ManagedBy" = "terraform"
}
database_name           = "proddb"
database_username       = "dbadmin"
database_engine         = "postgres"
database_engine_version = "16.3"
database_instance_type  = "db.t3.medium"
database_storage        = 20
public_subnets = {
  "public_1" = {
    cidr = "10.2.1.0/24"
    az   = "us-east-1a"
  }
  "public_2" = {
    cidr = "10.2.2.0/24"
    az   = "us-east-1b"
  }
}
private_subnets = {
  "private_1" = {
    cidr = "10.2.10.0/24"
    az   = "us-east-1a"
  }
  "private_2" = {
    cidr = "10.2.20.0/24"
    az   = "us-east-1b"
  }
}
allowed_ssh_cidr = "192.0.2.0/24"
environment      = "prod"
vpc_cidr = "10.2.0.0/16"
multi_az = true
email = "onaefe6@gmail.com"
cpu_threshold = 60
retention_in_days = 365