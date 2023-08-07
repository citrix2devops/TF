resource "aws_security_group" "aurora_db_sg" {
  name               = "${var.app_ci}-sg"
  description        = "${var.app_ci}-sg"
  vpc_id             = var.vpc_id

  ingress {
    description      = "Inbound VDI Access"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [ "10.233.72.0/21", "10.233.64.0/19", "10.233.112.0/21" ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [ "10.0.0.0/8" ]
  }

  tags = merge( local.tags, {"Name" : "${var.app_ci}-sg" })

  lifecycle {
    ignore_changes = [
      ingress,
      egress
    ]
  }
}

resource "aws_security_group_rule" "mq_sg" {
  type                      = "ingress"
  from_port                 = 3306
  to_port                   = 3306
  protocol                  = "tcp"
  description               = "Access from MQ"
  security_group_id         = aws_security_group.aurora_db_sg.id
  source_security_group_id  = var.mq_security_group_id
}