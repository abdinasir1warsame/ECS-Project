data "aws_secretsmanager_secret_version" "db_secret" {
  secret_id = "arn:aws:secretsmanager:eu-west-2:843036590237:secret:prod/memos/db-sUVf0O"
}

locals {
  db_secret = jsondecode(data.aws_secretsmanager_secret_version.db_secret.secret_string)

  db_name  = local.db_secret.db_name
  username = local.db_secret.username
  password = local.db_secret.password
  port     = local.db_secret.port
}

