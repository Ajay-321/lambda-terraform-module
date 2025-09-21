terraform {
  backend "s3" {
    bucket = "your backend s3 bucket"
    key    = "dev/us-east1/us-east1.tfstate" #updated as per your standard naming convention
    region = "us-east-1"                     #region
  }
}
