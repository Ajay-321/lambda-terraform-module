terraform {
  backend "s3" {
    bucket = "terraform-nsq-dev"
    key    = "cdc/us-east1/us-east1.tfstate"
    region = "us-east-1"
  }
}
