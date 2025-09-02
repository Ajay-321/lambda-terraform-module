data "aws_caller_identity" "current" {}

locals {
  create_lambda_resource = length(var.lambda_function) > 0
  account_id             = data.aws_caller_identity.current.account_id
}

# Ensure S3 object exists for the layer (created via GitHub Actions upload)
resource "aws_s3_object" "lambda_layer_zip" {
  bucket = module.lambda_bucket.s3_bucket_id
  key    = lambda/lambda_layer
}

# Lambda Layer Version
resource "aws_lambda_layer_version" "common_layer" {
  layer_name          = "common_dependencies"
  description         = "Pandas and Numpy dependencies"
  s3_bucket           = module.lambda_bucket.s3_bucket_id
  s3_key              = lambda/lambda_layer
  compatible_runtimes = ["python3.12"]

  # Force update when the uploaded object changes
  source_code_hash = aws_s3_object.lambda_layer_zip.etag

  depends_on = [aws_s3_object.lambda_layer_zip]
}

# ------------------------------
# Lambda Function Creation
# ------------------------------
module "lambda_function" {
  for_each   = var.lambda_function
  depends_on = [aws_s3_object.lambda_zip_objects]
  source     = "github.com/terraform-aws-modules/terraform-aws-lambda?ref=v8.0.1"

  function_name = each.value.function_name
  create        = each.value.create
  description   = each.value.description
  handler       = each.value.handler
  runtime       = each.value.runtime
  memory_size   = each.value.memory_size
  timeout       = each.value.timeout

  # Attach the common layer dynamically 
  layers = [aws_lambda_layer_version.common_layer.arn]


  create_package = false
  s3_existing_package = {
    bucket = module.lambda_bucket.s3_bucket_id
    key    = length(aws_s3_object.lambda_zip_objects) > 0 ? aws_s3_object.lambda_zip_objects[0].key : null
  }

  create_role            = false
  lambda_role            = "arn:aws:iam::${local.account_id}:role/${each.value.iam_role_name}"
  vpc_subnet_ids         = var.common_vars["subnet_ids"]
  vpc_security_group_ids = var.common_vars["vpc_security_group_id"]

  environment_variables = {
    Environment                         = var.common_vars["common_tags"]["Environment"]
    region                              = var.common_vars["region"]
    auth_method                         = each.value.lambda_config.auth_method
    GOOGLE_APPLICATION_CREDENTIALS      = each.value.lambda_config.credential_file_path
    dynamo_partition_key                = each.value.lambda_config.dynamo_partition_key
    dynamo_sort_key                     = each.value.lambda_config.dynamo_sort_key
    dynamo_log_table_name               = each.value.lambda_config.dynamodb_log_table_name
    GOOGLE_CLOUD_PROJECT                = each.value.lambda_config.google_cloud_project
    rds_dbname                          = each.value.lambda_config.rds_dbname
    rds_host                            = each.value.lambda_config.rds_host
    rds_user                            = each.value.lambda_config.rds_user
    rds_password                        = each.value.lambda_config.rds_password
    pubsub_subscription_list            = each.value.lambda_config.pubsub_subscription_list
    num_of_pubsub_message_to_process    = each.value.lambda_config.num_of_pubsub_message_to_process
    pubsub_read_message_timeout_seconds = each.value.lambda_config.pubsub_read_message_timeout_seconds
    sns_topic_arn                       = each.value.lambda_config.sns_topic_arn
  }

  tags = var.common_vars["common_tags"]
}
