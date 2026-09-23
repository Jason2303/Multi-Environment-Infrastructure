ami_id = "ami-05f991c49d264708f"
asg_sizes = {
  min_size         = 1
  max_size         = 1
  desired_capacity = 1
}
key_pair = "dev-keypair"
common_tags = {
  "Project"   = "terraform-multi-env",
  "ManagedBy" = "terraform"
}
database_name           = "devdb"
database_username       = "dbadmin"
database_engine         = "postgres"
database_engine_version = "16.3"
database_instance_type  = "db.t3.micro"
database_storage        = 20
public_subnets = {
  "public_1" = {
    cidr = "10.0.1.0/24"
    az   = "us-east-1a"
  }
  "public_2" = {
    cidr = "10.0.2.0/24"
    az   = "us-east-1b"
  }
}
private_subnets = {
  "private_1" = {
    cidr = "10.0.10.0/24"
    az   = "us-east-1a"
  }
  "private_2" = {
    cidr = "10.0.20.0/24"
    az   = "us-east-1b"
  }
}
allowed_ssh_cidr = "192.0.2.0/24"
environment      = "dev"
email = "onaefe6@gmail.com"
cpu_threshold = 80
retention_in_days = 14