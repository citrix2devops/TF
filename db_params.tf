resource "aws_db_parameter_group" "this" {
  name        = "${var.app_name}-rdsaurora-${var.env}-dbparametergroup"
  description = "This Parameter Group is assigned for  ${var.app_name}-rdsaurora DB Instance."
  family      = var.db_parameter_group_family

  parameter {
    name     = "general_log"
    value    = 1
  }

  parameter {
    name     = "slow_query_log"
    value    = 1
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}
