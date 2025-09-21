terraform {
  backend "s3" {
    bucket = "dev-test-bucket-43"
    key    = "dev/us-east1/us-east1.tfstate" #updated as per your standard naming convention
    region = "us-east-1"                     #region
  }
}
