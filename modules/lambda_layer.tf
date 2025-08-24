# Create Lambda layer from requirements.txt folder
module "lambda_layer_s3" {
  source = "terraform-aws-modules/lambda/aws"

  create_layer = true

  layer_name          = var.layer_name
  description         = "Shared dependencies for all Lambda functions"
  compatible_runtimes = ["python3.12"]

  # Path to your layer source (python/ folder inside lambda_layer)
  source_path = [
    {
      path             = "${path.module}/../../lambda/lambda_layer"
      pip_requirements = true     # Will run "pip install" with default "requirements.txt" from the path
      prefix_in_zip    = "python" # required to get the path correct
    }
  ]

  store_on_s3 = true
  s3_bucket   = module.lambda_bucket.s3_bucket_id # Upload layer to Lambda S3 bucket

  tags = {
    Name = "terraform-lambda-pandas-numpy-layer"
  }
}
