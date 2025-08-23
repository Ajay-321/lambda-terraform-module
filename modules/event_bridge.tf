# Iterate over original event_bridge variable
resource "aws_cloudwatch_event_rule" "lambda_schedule_rule" {
  for_each = { for k, v in var.event_bridge : k => v if v.create_event_bridge }

  name                = each.value.rule_name
  description         = each.value.description
  schedule_expression = each.value.schedule_expression
  state               = each.value.state
  tags                = var.common_vars.common_tags
}

# Event Target for Lambda
resource "aws_cloudwatch_event_target" "lambda_target" {
  for_each  = aws_cloudwatch_event_rule.lambda_schedule_rule
  rule      = each.value.name
  target_id = each.key
  arn       = module.lambda_function[each.key].lambda_function_arn
}


# Permission for EventBridge to invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  for_each      = aws_cloudwatch_event_rule.lambda_schedule_rule
  statement_id  = var.event_bridge[each.key].perm_statement_id
  action        = var.event_bridge[each.key].action
  function_name = module.lambda_function[each.key].lambda_function_name
  principal     = var.event_bridge[each.key].principal
  source_arn    = each.value.arn
}

