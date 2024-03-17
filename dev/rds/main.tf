resource "aws_db_instance" "rds_instance" {
  allocated_storage           = var.allocated_storage
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  db_name                     = var.db_name
  identifier                  = var.identifier
  username                    = var.username
  db_subnet_group_name        = aws_db_subnet_group.subnet_group.name
  parameter_group_name        = aws_db_parameter_group.parameter_group.name
  apply_immediately           = false
  manage_master_user_password = true # allow RDS to manage the master user password in Secrets Manager
  skip_final_snapshot         = true
  tags = {
    Name = "MyRDSInstance"
  }
}

resource "aws_db_subnet_group" "subnet_group" {
  name = "my-rds-subnet-group"
  subnet_ids = [
    var.private_1_id,
    var.private_2_id
  ]

  tags = {
    Name = "MyRDSSubnetGroup"
  }
}

resource "aws_db_parameter_group" "parameter_group" {
  name        = var.parameter_name
  family      = var.parameter_family
  description = "My RDS parameter group"

  parameter {
    name         = "shared_preload_libraries"
    value        = "pg_stat_statements,pg_cron"
    apply_method = "pending-reboot"
  }

   parameter {
    name         = "cron.database_name"
    value        = var.db_name
    apply_method = "pending-reboot"
  }

  tags = {
    Name = "MyRDSParameterGroup"
  }
}
