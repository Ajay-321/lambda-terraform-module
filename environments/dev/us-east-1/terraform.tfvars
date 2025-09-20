
common_tags = {
  created_with_terraform = "yes"
  Environment            = "dev"
  region                 = "us-east-1" #change with your region name
}

lambda_function = {
  dev = { #pass mapping variables like dev if you want to create multiple lambdas within same environment like qa, sandbox etc
    create        = true
    iam_role_name = " your lambda iam role with AWSLambdaBasicExecutionRole & AWSLambdaENIManagementAccess access"
    function_name = " your lambda name"
    description   = "Dev WIF Lambda function." # lambda description
    handler       = "lambda_function.lambda_handler"
    runtime       = "python3.12"
    memory_size   = 256
    timeout       = 900 #change as per your requirement.
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

sns_topic = {
  name        = "your sns topic"
  description = "Notifications for Lambda function Failure"
  emails      = ["your email id "]
}

event_bridge = {
  dev = {
    create_event_bridge = true
    rule_name           = "your eventbridge rule name"
    description         = "Triggers Lambda every 15 minutes" #change as per your requirement
    schedule_expression = "cron(0/15 * * * ? *)"
    state               = "ENABLED" #disable if you don't want to schedule lambda
    perm_statement_id   = "AllowExecutionFromEventBridge"
    action              = "lambda:InvokeFunction"
    principal           = "events.amazonaws.com"
  }
}

#lambda layer variables
layer_name        = "gcp lambda layer name"
layer_bucket_name = "layer bucket name which will be used to store layer zip file created by build_layer.sh script during github actions" 