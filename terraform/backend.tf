terraform {
  backend "s3" {
    bucket = "pepu-your-terraform-state-bucket"
    key    = "ecs/hello-world-app/terraform.tfstate"
    region = "us-east-1"
  }
}