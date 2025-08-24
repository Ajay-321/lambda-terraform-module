terraform {
  backend "s3" {
    bucket = "dev-test-bucket-43"
    key    = "dev/us-east1/us-east1.tfstate"
    region = "us-east-1"
  }
}
