terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.us_east_1]
    }
  }
}

resource "aws_sns_topic" "alerts" {
  name = "app-alerts-topic"
}

resource "aws_sns_topic" "alerts_us_east_1" {
  provider = aws.us_east_1
  name     = "app-alerts-topic-us-east-1"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "mykhailo.lypko.ri.2024@lpnu.ua" 
}

resource "aws_sns_topic_subscription" "email_sub_us_east_1" {
  provider   = aws.us_east_1
  topic_arn  = aws_sns_topic.alerts_us_east_1.arn
  protocol   = "email"
  endpoint   = "mykhailo.lypko.ri.2024@lpnu.ua"
}

resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "lambda-error-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
  alarm_description   = "This metric monitors lambda function errors for save_course"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    FunctionName = "lp-dev-lab1-save-course" 
  }
}

resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  provider            = aws.us_east_1 
  alarm_name          = "billing-alarm-over-5usd"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "21600" 
  statistic           = "Maximum"
  threshold           = "5"
  alarm_description   = "Alarm if AWS charges exceed $5"
  alarm_actions       = [aws_sns_topic.alerts_us_east_1.arn]

  dimensions = {
    Currency = "USD"
  }
}