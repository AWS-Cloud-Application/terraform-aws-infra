# Lambda Function for Email Verification
resource "aws_lambda_function" "email_verification" {
  depends_on    = [aws_secretsmanager_secret.email_service_credentials]
  function_name = "${var.vpc_name}-email-verification"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "serverless-forked/index.handler"
  runtime       = "nodejs18.x"
  timeout       = 120

  filename = "${path.module}/serverless-forked.zip"

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.user_registration_topic.arn
    }
  }
}


# Grant SNS permission to invoke Lambda
resource "aws_lambda_permission" "allow_sns_invoke_lambda" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.email_verification.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.user_registration_topic.arn
}