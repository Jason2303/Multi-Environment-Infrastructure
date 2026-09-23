# When running terraform apply, create `backend-bucket-3112` in the AWS console
# Uncomment when deploying 
#
# terraform {
#   backend "s3" {
#     bucket         = "backend-bucket-3112"
#     key            = "prod/terraform.tfstate"
#     region         = "us-east-1"
#     use_lockfile   = true
#     encrypt        = true
#   }
# }