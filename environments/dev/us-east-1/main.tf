##dev module
module "dev" {
  source            = "../../../modules"
  lambda_function   = var.lambda_function
  lambda_bucket     = var.lambda_bucket
  common_tags       = var.common_tags
  sns_topic         = var.sns_topic
  event_bridge      = var.event_bridge
  layer_name        = var.layer_name
  layer_bucket_name = var.layer_bucket_name
}
