
common_tags = {
  created_with_terraform = "yes"
  Environment            = "dev"
  region                 = "us-east-1" #change with your region name
}

lambda_function = {
  dev = {
    create        = true
    iam_role_name = "dev-lambda-function-role"
    function_name = "dev-us-east-1-wif-lambda"
    description   = "Dev WIF Lambda function." # lambda description
    handler       = "lambda_function.lambda_handler"
    runtime       = "python3.12"
    memory_size   = 256
    timeout       = 900 #change as per your requirement.
    lambda_config = {
      credential_file_path = "workload_identity_config.json" #wif credentials file path
      google_cloud_project = "dev-wif-demo-project"
      gcs_bucket_name      = "dev-wif-demo-bucket"
    }
  }
}

#lambda bucket to store code zip file
lambda_bucket = {
  create = true
  versioning = {
    enabled = true
  }
  policy_json = {
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowRootAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::214408080534:root"
        }
        Action = "s3:*"
        Resource = [
          "arn:aws:s3:::dev-us-east-1-lambda-bucket-new2"
        ]
      }
    ]
  }
}

#lambda layer variables
layer_name        = "gcp-wif-layer-new"
layer_bucket_name = "dev-test-bucket-43" 