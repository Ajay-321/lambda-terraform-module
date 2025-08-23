# output "lambda_functions" {
#   description = "Details of all created Lambda functions"
#   value = {
#     for k, v in module.lambda_function :
#     k => {
#       name = v.lambda_function_name
#       arn  = v.lambda_function_arn
#     }
#   }
# }

# output "eventbridge_rules" {
#   description = "Details of all created EventBridge rules"
#   value = {
#     for k, v in module.event_bridge :
#     k => {
#       name = v.event_rule_name
#       arn  = v.event_rule_arn
#     }
#   }
# }

# output "sns_topic_arn" {
#   description = "ARN of the SNS topic"
#   value       = aws_sns_topic.sns_topic.arn
# }
