locals{
    tags  = {
        ApplicationCI        = var.app_ci
        SLALevel             = var.sla_level
        RiskDataClass        = var.risk_data_class
        ApplicationContactDL = var.app_contact_dl
        InternalExternal     = var.internal_external
        RegulatoryControls   = var.regulatory_controls
    }
}

resource "aws_db_subnet_group" "this" {
  name        = "${var.app_name}-${var.env}-dbsubnetgroup"
  description = "Database subnet group for ${var.app_name} Aurora DB Cluster."
  subnet_ids  = var.subnet_ids
  tags        = local.tags
}

resource "aws_rds_cluster" "this" {
  availability_zones                  = var.availability_zones 
  backup_retention_period             = 15
  cluster_identifier                  = "${var.app_name}-rdsaurora-cluster-${var.region}-${var.env}"
  cluster_identifier_prefix           = "${var.app_name}-rdsaurora-cluster"
  copy_tags_to_snapshot               = true
  database_name                       = "${var.app_ci}-rdsauroradbcluster"
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.this.name
  db_subnet_group_name                = aws_db_subnet_group.this.name
  deletion_protection                 = true
  engine                              = var.engine
  engine_version                      = var.engine_version
  master_password                     = var.master_pwd
  master_username                     = var.master_usr
  port                                = var.port
  preferred_backup_window             = "3:30-4:00"
  preferred_maintenance_window        = "Sun:4:30-Sun:05:00"
  storage_encrypted                   = true


  serverlessv2_scaling_configuration {
    content {
      max_capacity             = 2
      min_capacity             = 1
    }
  }

  tags                   = local.tags
  vpc_security_group_ids = aws_security_group.aurora_db_sg.id


  lifecycle {
    ignore_changes = [
      # See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster#replication_source_identifier
      # Since this is used either in read-replica clusters or global clusters, this should be acceptable to specify
      replication_source_identifier,
      # See docs here https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_global_cluster#new-global-cluster-from-existing-db-cluster
      global_cluster_identifier,
      snapshot_identifier,
    ]
  }
}


resource "aws_rds_cluster_instance" "master_db" {
  cluster_identifier                    = aws_rds_cluster.this.id
  copy_tags_to_snapshot                 = true
  db_parameter_group_name               = aws_db_parameter_group.this.id
  db_subnet_group_name                  = aws_db_subnet_group.this.name
  engine                                = var.engine
  engine_version                        = var.engine_version
  identifier                            = "${var.app_name}-rdsaurora-master-inst-${var.region}-${var.env}"
  identifier_prefix                     = "${var.app_name}-rdsaurora-master-inst"
  instance_class                        = var.instance_class
  performance_insights_enabled          = true
  storage_encrypted                     = true
  publicly_accessible                   = false
  tags                                  = merge(local.tags,{"MaintenanceWindow" : "Sun:4:30-Sun:05:00" }
}

resource "aws_rds_cluster_instance" "replica_db" {
  cluster_identifier                    = aws_rds_cluster.this.id
  copy_tags_to_snapshot                 = true
  db_parameter_group_name               = aws_db_parameter_group.this.id
  db_subnet_group_name                  = aws_db_subnet_group.this.name
  engine                                = var.engine
  engine_version                        = var.engine_version
  identifier                            = "${var.app_name}-rdsaurora-replica-inst-${var.region}-${var.env}"
  identifier_prefix                     = "${var.app_name}-rdsaurora-replica-inst"
  instance_class                        = var.instance_class
  performance_insights_enabled          = true
  storage_encrypted                     = true
  publicly_accessible                   = false
  tags                                  = merge(local.tags,{"MaintenanceWindow" : "Sun:06:00-Sun:06:30" }
}
