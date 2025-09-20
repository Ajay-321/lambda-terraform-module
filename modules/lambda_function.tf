data "aws_caller_identity" "current" {}

locals {
  create_lambda_resource = length(var.lambda_function) > 0
  account_id             = data.aws_caller_identity.current.account_id
}

# Ensure S3 object exists for the layer (created via GitHub Actions upload)
resource "aws_s3_object" "lambda_layer_zip" {
  bucket = var.layer_bucket_name
  key    = "lambda/lambda_layer/layer.zip"
}

# Lambda Layer Version
resource "aws_lambda_layer_version" "common_layer" {
  layer_name          = var.layer_name
  description         = "Lambda dependencies layer"
  s3_bucket           = var.layer_bucket_name
  s3_key              = "lambda/lambda_layer/layer.zip"
  compatible_runtimes = ["python3.12"]

  depends_on = [aws_s3_object.lambda_layer_zip]
}

# ------------------------------
# Lambda Function Creation
# ------------------------------
module "lambda_function" {
  for_each   = var.lambda_function
  depends_on = [aws_s3_object.lambda_zip_objects]
  source     = "github.com/terraform-aws-modules/terraform-aws-lambda?ref=v8.0.1"

  function_name          = each.value.function_name
  create                 = each.value.create
  description            = each.value.description
  handler                = each.value.handler
  runtime                = each.value.runtime
  memory_size            = each.value.memory_size
  timeout                = each.value.timeout
  vpc_subnet_ids         = each.value.subnet_ids
  vpc_security_group_ids = each.values.vpc_security_group_id

  # Attach the common layer dynamically 
  layers = [aws_lambda_layer_version.common_layer.arn]


  create_package = false
  s3_existing_package = {
    bucket = module.lambda_bucket.s3_bucket_id
    key    = length(aws_s3_object.lambda_zip_objects) > 0 ? aws_s3_object.lambda_zip_objects[0].key : null
  }

  create_role = false
  lambda_role = "arn:aws:iam::${local.account_id}:role/${each.value.iam_role_name}"


  environment_variables = {
    GOOGLE_APPLICATION_CREDENTIALS = each.value.lambda_config.credential_file_path
    GOOGLE_CLOUD_PROJECT           = each.value.lambda_config.google_cloud_project
    GCS_BUCKET_NAME                = each.value.lambda_config.gcs_bucket_name
  }

  tags = var.common_tags
}
