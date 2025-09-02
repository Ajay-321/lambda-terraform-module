common_vars = {
  vpc_id                = "vpc-01e98e8ed0e9fd133"
  vpc_security_group_id = ["sg-0c4ffdb536de63b0c"]
  region                = "us-east-1"
  common_tags = {
    Terraform   = "true"
    Environment = "dev"
    aws_region  = "us-east-1"
  }
  subnet_ids = ["subnet-0338c7a813db0dd58", "subnet-09ef2eb9629361b94"]
}

lambda_function = {
  dev = {
    create        = true
    iam_role_name = "lambda_function_role"
    function_name = "dev-us-east-1-lambda"
    description   = "Dev Lambda function."
    handler       = "lambda_function.lambda_handler"
    runtime       = "python3.12"
    memory_size   = 256
    timeout       = 900
    lambda_config = {
      cluster_name                        = "dev"
      auth_method                         = "WIF"
      credential_file_path                = "workload_identity_config.json"
      dynamodb_log_table_name             = "dev-us-east-1-dynamo-table"
      dynamo_partition_key                = "file_path"
      dynamo_sort_key                     = "query_id"
      google_cloud_project                = "dev-test-project"
      pubsub_subscription_list            = "dev-topic-subscription"
      rds_dbname                          = "test_db"
      rds_user                            = "test"
      rds_password                        = "test@123"
      rds_host                            = "dev-testdb.cluster-cd897v.us-east-1.rds.amazonaws.com"
      region                              = "us-east-1"
      sns_topic_arn                       = "arn:aws:sns:us-east-1:214408080534:dev-us-east-1-snstopic"
      num_of_pubsub_message_to_process    = 75
      pubsub_read_message_timeout_seconds = 30
    }
  },
  devint = {
    create        = true
    iam_role_name = "lambda_function_role"
    function_name = "devint-us-east-1-lambda"
    description   = "Devint Lambda function."
    handler       = "lambda_function.lambda_handler"
    runtime       = "python3.12"
    memory_size   = 256
    timeout       = 900
    lambda_config = {
      cluster_name                        = "dev"
      auth_method                         = "WIF"
      credential_file_path                = "workload_identity_config.json"
      dynamodb_log_table_name             = "dev-us-east-1-dynamo-table"
      dynamo_partition_key                = "file_path"
      dynamo_sort_key                     = "query_id"
      google_cloud_project                = "dev-test-project"
      pubsub_subscription_list            = "dev-topic-subscription"
      rds_dbname                          = "test_db"
      rds_user                            = "test"
      rds_password                        = "test@123"
      rds_host                            = "dev-testdb.cluster-cd897v.us-east-1.rds.amazonaws.com"
      region                              = "us-east-1"
      sns_topic_arn                       = "arn:aws:sns:us-east-1:214408080534:dev-us-east-1-snstopic"
      num_of_pubsub_message_to_process    = 75
      pubsub_read_message_timeout_seconds = 30
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
  name        = "dev-us-east-1-snstopic"
  description = "Notifications for Lambda function Failure"
  emails      = ["ajay10795@gmail.com"]
}

event_bridge = {
  dev = {
    create_event_bridge = true
    rule_name           = "dev-us-east-1-rule"
    description         = "Triggers Lambda every 15 minutes"
    schedule_expression = "cron(0/15 * * * ? *)"
    state               = "DISABLED"
    perm_statement_id   = "AllowExecutionFromEventBridge"
    action              = "lambda:InvokeFunction"
    principal           = "events.amazonaws.com"
  },
  devint = {
    create_event_bridge = true
    rule_name           = "devint-us-east-1-rule"
    description         = "Triggers Lambda every 15 minutes"
    schedule_expression = "cron(0/15 * * * ? *)"
    state               = "DISABLED"
    perm_statement_id   = "AllowExecutionFromEventBridge"
    action              = "lambda:InvokeFunction"
    principal           = "events.amazonaws.com"
  }
}


layer_name = "pandas_numpy_layer"