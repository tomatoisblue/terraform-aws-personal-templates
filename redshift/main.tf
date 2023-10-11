module "redshift" {
  source = "./module"

  cluster_identifier      = "my-cluster"
  cluster_node_type       = "dc2.large"
  cluster_number_of_nodes = 2

  cluster_database_name   = "my_redshift_db"
  cluster_master_username = "admin"
  cluster_master_password = "MyPassword01"

  subnets = ["subnet-d3b78288"]

  vpc_security_group_ids = ["sg-d4e99ea4"]

  # force it to go through VPC
  enhanced_vpc_routing = true
  # make it accessible from outside VPC
  publicly_accessible = true

  encrypted = true

  automated_snapshot_retention_period = 7
}