
common_tags = {
  created_with_terraform = "yes"
  Environment            = "dev"
  region                 = "us-east-1" #change with your region name
}

lambda_function = {
  dev = {                        #pass mapping variables like dev if you want to create multiple lambdas within same environment like qa, sandbox etc
    create                = true # if we don't want to deploy lambda in some env, keep this variable false
    iam_role_name         = " your lambda iam role with AWSLambdaBasicExecutionRole & AWSLambdaENIManagementAccess access"
    function_name         = " your lambda name"
    description           = "Dev WIF Lambda function." # lambda description
    handler               = "lambda_function.lambda_handler"
    runtime               = "python3.12"
    memory_size           = 256
    timeout               = 900 #change as per your requirement.
    vpc_id                = "your vpc"
    vpc_security_group_id = [" lambda security group"]
    region                = "us-east-1" #region
    subnet_ids            = ["private_subnet_az1", "private_subnet_az2"]
    lambda_config = {
      credential_file_path = "workload_identity_config.json" #wif credentials file path
      google_cloud_project = "gcp project name"
      gcs_bucket_name      = "gcs bucket name"
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
          AWS = "arn:aws:iam::<account id>:root"
        }
        Action = "s3:*"
        Resource = [
          "arn:aws:s3:::<lambda bucket name"
        ]
      }
    ]
  }
}

#lambda layer variables
layer_name        = "gcp lambda layer name"
layer_bucket_name = "layer bucket name which will be used to store layer zip file created by build_layer.sh script during github actions"
