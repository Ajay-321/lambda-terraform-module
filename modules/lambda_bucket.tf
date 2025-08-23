# locals {
#   lambda_bucket_name = "q-${var.common_vars.common_tags.Environment}-${var.common_vars.region}-lambda-bucket"
# }

# resource "aws_s3_bucket_policy" "lambda_bucket_policy" {
#   count  = var.lambda_bucket["create"] ? 1 : 0
#   bucket = module.lambda_bucket.s3_bucket_id
#   policy = jsonencode(var.lambda_bucket.policy_json)
# }

# module "lambda_bucket" {
#   source        = "github.com/terraform-aws-modules/terraform-aws-s3-bucket.git?ref=v5.5.0"
#   create_bucket = var.lambda_bucket["create"]
#   bucket        = local.lambda_bucket_name
#   tags          = var.common_vars.common_tags
#   versioning    = var.lambda_bucket["versioning"]
#   logging = {}
#   server_side_encryption_configuration = {
#     rule = {
#       apply_server_side_encryption_by_default = {
#         sse_algorithm     = lookup(var.lambda_bucket, "kms_key_id", null) != null ? "aws:kms" : "AES256"
#         kms_master_key_id = lookup(var.lambda_bucket, "kms_key_id", null)
#       }
#     }
#   }
# }

# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_dir  = "../lambda/lambda_code/"
#   output_path = "../lambda/lambda_code_${timestamp()}.zip"
# }

# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_dir  = "${path.root}/../../lambda/lambda_code/"
#   output_path = "${path.root}/../../lambda/lambda_code_20250822.zip"
# }

# resource "aws_s3_object" "lambda_zip_objects" {
#   count  = var.lambda_bucket["create"] ? 1 : 0
#   bucket = module.lambda_bucket.s3_bucket_id
#   key    = "lambda/${basename(data.archive_file.lambda_zip.output_path)}"
#   source = data.archive_file.lambda_zip.output_path
#   etag   = filemd5("${path.root}/../../lambda/${basename(data.archive_file.lambda_zip.output_path)}")
# }

locals {
  lambda_bucket_name = "q-${var.common_vars.common_tags.Environment}-${var.common_vars.region}-lambda-bucket"
}

resource "aws_s3_bucket_policy" "lambda_bucket_policy" {
  count  = var.lambda_bucket["create"] ? 1 : 0
  bucket = module.lambda_bucket.s3_bucket_id
  policy = jsonencode(var.lambda_bucket.policy_json)
}

module "lambda_bucket" {
  source        = "github.com/terraform-aws-modules/terraform-aws-s3-bucket.git?ref=v5.5.0"
  create_bucket = var.lambda_bucket["create"]
  bucket        = local.lambda_bucket_name
  tags          = var.common_vars.common_tags
  versioning    = var.lambda_bucket["versioning"]
  logging       = {}
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = lookup(var.lambda_bucket, "kms_key_id", null) != null ? "aws:kms" : "AES256"
        kms_master_key_id = lookup(var.lambda_bucket, "kms_key_id", null)
      }
    }
  }
}

# ------------------------------
# Lambda Function ZIP Packaging
# ------------------------------
# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_dir  = "${path.root}/../../lambda/lambda_code/"
#   output_path = "${path.root}/../../lambda/lambda_code_20250823142100.zip"
# }

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "../lambda/lambda_code/"
  output_path = "../lambda/lambda_code_${timestamp()}.zip"
}


resource "aws_s3_object" "lambda_zip_objects" {
  count  = var.lambda_bucket["create"] ? 1 : 0
  bucket = module.lambda_bucket.s3_bucket_id
  key    = "lambda/${basename(data.archive_file.lambda_zip.output_path)}"
  source = data.archive_file.lambda_zip.output_path
  etag   = filemd5(data.archive_file.lambda_zip.output_path)
}


