resource "aws_rds_cluster_parameter_group" "this" {
  name        = "${var.app_name}-rdsaurora-${var.env}-clusterparametergroup"
  description = "This Parameter Group is assigned for ${var.app_name}-rdsaurora Cluster."
  family      = var.db_cluster_parameter_group_family

  parameter {
    name     = "time_zone"
    value    = "US/Eastern"
  }

  parameter {
    name     = "slow_query_log"
    value    = 1
  }

  parameter {
    name     = "server_audit_logging"
    value    = 1
  }

  parameter {
    name     = "server_audit_events"
    value    = "CONNECT,QUERY_DCL,QUERY_DDL"
  }

  parameter {
    name     = "general_log"
    value    = 1
  }

  parameter {
    name     = "require_secure_transport"
    value    = "ON"
  }

  parameter {
    name     = "event_scheduler"
    value    = "ON"
  }


  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}
