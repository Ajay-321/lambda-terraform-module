common_vars = {
  vpc_id                = "vpc-0df88a8112a62efd8"
  vpc_security_group_id = ["sg-06cb4082bec56dd09"]
  region                = "us-east-1"
  common_tags = {
    Terraform   = "true"
    Environment = "dev"
    aws_region  = "us-east-1"
  }
  subnet_ids = ["subnet-0f6c5cb3a64fe6a50", "subnet-0a1810a35106e97b7"]
}

lambda_function = {
  dev1 = {
    create        = true
    iam_role_name = "dev1-lambda-function-role"
    function_name = "dev1-us-east-1-wif-lambda"
    description   = "Dev Lambda function."
    handler       = "lambda_function.lambda_handler"
    runtime       = "python3.12"
    memory_size   = 256
    timeout       = 900
    lambda_config = {
      credential_file_path = "workload_identity_config.json"
      google_cloud_project = "dev1-wif-demo-project"
      gcs_bucket_name      = "dev1-wif-demo-bucket"

    }
  },
  dev2 = {
    create        = true
    iam_role_name = "dev1-lambda-function-role"
    function_name = "dev2-us-east-1-wif-lambda"
    description   = "Devint Lambda function."
    handler       = "lambda_function.lambda_handler"
    runtime       = "python3.12"
    memory_size   = 256
    timeout       = 900
    lambda_config = {
      cluster_name         = "dev"
      auth_method          = "WIF"
      credential_file_path = "workload_identity_config.json"
      google_cloud_project = "dev1-wif-demo-project"
      gcs_bucket_name      = "dev1-wif-demo-bucket"
    }
  }
}


lambda_bucket = {
  create = true
  versioning = {
    enabled = true
  }
  target_prefix = "log/Lambda_bucket"
  target_object_key_format = {
    partitioned_prefix = {
      partition_date_source = "EventTime"
    }
  }
  files_list = {}
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
          "arn:aws:s3:::dev-us-east-1-lambda-bucket-new"
        ]
      }
    ]
  }
}

sns_topic = {
  name        = "dev1-us-east-1-snstopic"
  description = "Notifications for Lambda function Failure"
  emails      = ["ajay10795@gmail.com"]
}

event_bridge = {
  dev1 = {
    create_event_bridge = true
    rule_name           = "dev1-us-east-1-rule"
    description         = "Triggers Lambda every 15 minutes"
    schedule_expression = "cron(0/15 * * * ? *)"
    state               = "DISABLED"
    perm_statement_id   = "AllowExecutionFromEventBridge"
    action              = "lambda:InvokeFunction"
    principal           = "events.amazonaws.com"
  },
  dev2 = {
    create_event_bridge = true
    rule_name           = "dev2-us-east-1-rule"
    description         = "Triggers Lambda every 15 minutes"
    schedule_expression = "cron(0/15 * * * ? *)"
    state               = "DISABLED"
    perm_statement_id   = "AllowExecutionFromEventBridge"
    action              = "lambda:InvokeFunction"
    principal           = "events.amazonaws.com"
  }
}


layer_name        = "gcp_lambda_layer"
layer_bucket_name = "dev1-test-bucket-43"