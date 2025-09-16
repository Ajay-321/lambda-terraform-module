common_vars = {
  vpc_id                = "your vpc id"
  vpc_security_group_id = ["security group id with outbound access to internet"]
  region                = "your region name"
  common_tags = {
    Environment = "dev"
    aws_region  = "your region name"
  }
  subnet_ids = ["private_subnet_az1", "private_subnet_az2"]
}

lambda_function = {
  dev = {
    create        = true
    iam_role_name = "dev-lambda-function-role" # your lambda iam role with AWSLambdaBasicExecutionRole & AWSLambdaENIManagementAccess access
    function_name = "dev-us-east-1-wif-lambda" # your lambda name
    description   = "Dev WIF Lambda function." # lambda description
    handler       = "lambda_function.lambda_handler"
    runtime       = "python3.12"
    memory_size   = 256
    timeout       = 900
    lambda_config = {
      credential_file_path = "workload_identity_config.json" #wif credentials file path
      google_cloud_project = "" # gcp project name
      gcs_bucket_name      = "" #gcs bucket name

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
          "arn:aws:s3:::<lambda bucket name>"
        ]
      }
    ]
  }
}

sns_topic = {
  name        = "dev-us-east-1-snstopic" # your sns topic name
  description = "Notifications for Lambda function Failure"
  emails      = ["email id"]
}

event_bridge = {
  dev = {
    create_event_bridge = true
    rule_name           = "dev-us-east-1-rule" # your eventbridge rule name
    description         = "Triggers Lambda every 15 minutes"
    schedule_expression = "cron(0/15 * * * ? *)"
    state               = "DISABLED"
    perm_statement_id   = "AllowExecutionFromEventBridge"
    action              = "lambda:InvokeFunction"
    principal           = "events.amazonaws.com"
  }
}

#lambda layer variables
layer_name        = " layer name"
layer_bucket_name = "layer bucket name" 