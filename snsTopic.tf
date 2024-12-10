# SNS Topic
resource "aws_sns_topic" "user_registration_topic" {
  name = "${var.vpc_name}-user-registration-topic"

  tags = {
    Name = "${var.vpc_name}-sns-topic"
  }
}

# SNS Topic Subscription for Lambda
resource "aws_sns_topic_subscription" "lambda_sns_subscription" {
  topic_arn = aws_sns_topic.user_registration_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.email_verification.arn
}