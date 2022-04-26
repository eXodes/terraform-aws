output "vpd_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  value = join(", ", module.vpc.private_subnets_cidr_blocks)
}

output "public_subnets" {
  value = join(", ", module.vpc.public_subnets_cidr_blocks)
}

output "nat_public_ip" {
  value = module.vpc.nat_public_ips[0]
}

output "database_address" {
  value = module.db.db_instance_address
}
