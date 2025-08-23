# Create the SNS Topic
resource "aws_sns_topic" "sns_topic" {
  name         = var.sns_topic["name"]
  display_name = var.sns_topic["description"]
  tags         = var.common_vars["common_tags"]
}

# Create Email Subscriptions (multiple subscribers per topic)
resource "aws_sns_topic_subscription" "email_subscriptions" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "email"
  endpoint  = var.sns_topic["emails"][0]
}

# Create SNS Topic Policy
resource "aws_sns_topic_policy" "policies" {
  arn = aws_sns_topic.sns_topic.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "cloudwatch.amazonaws.com" }
      Action    = "sns:Publish"
      Resource  = aws_sns_topic.sns_topic.arn
    }]
  })
}
