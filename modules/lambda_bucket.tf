
resource "aws_s3_bucket_policy" "lambda_bucket_policy" {
  count  = var.lambda_bucket["create"] ? 1 : 0
  bucket = module.lambda_bucket.s3_bucket_id
  policy = jsonencode(var.lambda_bucket.policy_json)
}

module "lambda_bucket" {
  source        = "github.com/terraform-aws-modules/terraform-aws-s3-bucket.git?ref=v5.5.0"
  create_bucket = var.lambda_bucket["create"]
  bucket        = "${var.common_vars["common_tags"]["Environment"]}-${var.common_vars["region"]}-lambda-bucket-new"
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

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.root}/../../lambda/lambda_code/"
  output_path = "${path.root}/../../lambda/lambda_code_${timestamp()}.zip"
}

resource "aws_s3_object" "lambda_zip_objects" {
  count  = var.lambda_bucket["create"] ? 1 : 0
  bucket = module.lambda_bucket.s3_bucket_id
  key    = "lambda/${basename(data.archive_file.lambda_zip.output_path)}"
  source = data.archive_file.lambda_zip.output_path
  etag   = filemd5("${path.root}/../../lambda/${basename(data.archive_file.lambda_zip.output_path)}")
}

# # Create a ZIP archive reference
# data "archive_file" "lambda_layer_zip" {
#   type        = "zip"
#   source_file = "${path.module}/lambda/lambda_layer/layer.zip"
#   output_path = "${path.module}/lambda/lambda_layer/layer-final.zip"
# }

# # Upload layer to S3
# resource "aws_s3_object" "lambda_layer_zip" {
#   bucket = module.lambda_bucket.s3_bucket_id
#   key    = "layers/common_layer.zip"
#   source = data.archive_file.lambda_layer_zip.output_path
#   etag   = filemd5(data.archive_file.lambda_layer_zip.output_path)
# }

# # Create Lambda Layer version
# resource "aws_lambda_layer_version" "common_layer" {
#   layer_name          = "common_dependencies"
#   description         = "Pandas and Numpy dependencies"
#   s3_bucket           = aws_s3_object.lambda_layer_zip.bucket
#   s3_key              = aws_s3_object.lambda_layer_zip.key
#   compatible_runtimes = ["python3.12"]
#   source_code_hash    = filebase64sha256(data.archive_file.lambda_layer_zip.output_path)
# }
