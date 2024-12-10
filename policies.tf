# IAM Policy for S3 and RDS access
resource "aws_iam_policy" "S3_access_policy" {
  name        = "${var.vpc_name}-access-policy"
  description = "IAM policy for S3 and RDS access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:PutLifecycleConfiguration",
          "s3:PutObjectAcl",
          "s3:GetObjectAcl",
          "s3:PutBucketAcl"
        ]
        Resource = [
          "${aws_s3_bucket.csye6225_s3_bucket.arn}/*",
          "${aws_s3_bucket.csye6225_s3_bucket.arn}"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances",
          "rds:Connect"
        ]
        Resource = aws_db_instance.rds_instance.arn
      }
    ]
  })
}

# Attach policy to EC2 role
resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.S3_access_policy.arn
}

# IAM Policy to allow CloudWatch actions
resource "aws_iam_policy" "cloudwatch_agent_policy" {
  name        = "CloudWatchAgentPolicy"
  description = "Allows CloudWatch agent to publish metrics and logs and describe EC2 tags"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "cloudwatch:PutMetricData",
          "ec2:DescribeTags",
          "cloudwatch:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Attach policy to IAM Role
resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.cloudwatch_agent_policy.arn
}


# Auto Scaling Policy for Scaling Up
resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "${var.vpc_name}-scale-up-policy"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}

# Auto Scaling Policy for Scaling Down
resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "${var.vpc_name}-scale-down-policy"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}


# IAM Policy for SNS access in Lambda
resource "aws_iam_policy" "ec2_sns_publish_policy" {
  name        = "${var.vpc_name}-ec2-sns-publish-policy"
  description = "Allow EC2 instances to publish to the SNS topic"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sns:Publish"
        ],
        Resource = aws_sns_topic.user_registration_topic.arn
      }
    ]
  })
}

# Attach the SNS Publish Policy to EC2 Role
resource "aws_iam_role_policy_attachment" "attach_ec2_sns_publish_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_sns_publish_policy.arn
}

# EC2 Secrets Manager Policy
resource "aws_iam_policy" "secretsmanager_access_policy" {
  name        = "${var.vpc_name}-secretsmanager-policy"
  description = "Allow EC2 instances to retrieve secrets from Secrets Manager"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = [
          aws_secretsmanager_secret.db_password_secret.arn,
          aws_secretsmanager_secret.email_service_credentials.arn
        ]
      }
    ]
  })
}

# Attach Secrets Manager Policy to EC2 Role
resource "aws_iam_role_policy_attachment" "attach_secretsmanager_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.secretsmanager_access_policy.arn
}

# Inline Policy for Lambda Secrets Manager Access
resource "aws_iam_role_policy" "lambda_secretsmanager_policy" {
  name = "${var.vpc_name}-lambda-secrets-policy"
  role = aws_iam_role.lambda_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Allow access to the secret
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = [
          aws_secretsmanager_secret.email_service_credentials.arn
        ]
      },
      # Allow decrypt access to the KMS key associated with the secret
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt"
        ],
        Resource = [
          aws_kms_key.secrets_kms.arn
        ]
      }
    ]
  })
}
