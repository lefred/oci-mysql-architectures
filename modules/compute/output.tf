output "private_ip" {
  value = join(", ", oci_core_instance.compute.*.private_ip)
}


output "public_ip" {
  value = var.assign_public_ip ? join(", ", oci_core_instance.compute.*.public_ip) : ""
}
