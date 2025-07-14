
output "ssh_private_key" {
  value = local.private_key_to_show
  sensitive = true
}

output "puppertserver_public_ip" {
  value = module.puppetserver.*.public_ip
}

output "source_computes_private_ips" {
  value = module.compute_instances_source.private_ip
}

output "replica_computes_private_ips" {
  value = module.compute_instances_replica.private_ip
}

output "source_routers_private_ips" {
  value = module.compute_instances_router_source.private_ip
}

output "source_routers_public_ips" {
  value = module.compute_instances_router_source.public_ip
}

output "replica_routers_private_ips" {
  value = module.compute_instances_router_replica.private_ip
}

output "replica_routers_public_ips" {
  value = module.compute_instances_router_replica.public_ip
}
