resource "aws_secretsmanager_secret" "auroradb_scts" {
  name                    = var.db_secret_name
  description             = "Database secrets."
  recovery_window_in_days = 0
  tags                    = var.tags
}

data "template_file" "auroradb_scts" {
  template = "${file("${path.module}/configs/auroradb_scts.json")}"

  vars = {
    usr   = var.master_usr
    pwd   = var.master_pwd
  }
}


resource "aws_secretsmanager_secret_version" "auroradb_scts" {
  secret_id     = aws_secretsmanager_secret.auroradb_scts.id
  secret_string = data.template_file.auroradb_scts.rendered
}