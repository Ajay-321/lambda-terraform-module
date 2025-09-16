terraform {
  backend "s3" {
    bucket = "backend s3 bucket"
    key    = "dev/us-east1/us-east1.tfstate"
    region = "us-east-1"
  }
}
