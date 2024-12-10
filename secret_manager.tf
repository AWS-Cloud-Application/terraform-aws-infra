resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!^*()-_[]{}|,<>?"
}

resource "aws_secretsmanager_secret" "db_password_secret" {
  name                    = "${var.vpc_name}-db-password"
  kms_key_id              = aws_kms_key.secrets_kms.id
  description             = "Database password for RDS instance"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_password_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_password_secret.id
  secret_string = jsonencode({ "password" = random_password.db_password.result })
}

resource "aws_secretsmanager_secret" "email_service_credentials" {
  name                    = "email-service-credentials"
  description             = "Credentials for the email service used by Lambda"
  kms_key_id              = aws_kms_key.secrets_kms.id
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "email_service_credentials_version" {
  secret_id     = aws_secretsmanager_secret.email_service_credentials.id
  secret_string = jsonencode({ "sendgrid_api_key" = var.sendgrid_api_key })
}
