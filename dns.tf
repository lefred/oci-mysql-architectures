data "oci_core_vcn_dns_resolver_association" "mysqlvcn1" {
  depends_on = [ oci_core_virtual_network.mysqlvcn1 ]
  vcn_id = oci_core_virtual_network.mysqlvcn1.id
  provider = oci.source
}

data "oci_core_vcn_dns_resolver_association" "mysqlvcn2" {
  depends_on = [ oci_core_virtual_network.mysqlvcn2 ]
  vcn_id = oci_core_virtual_network.mysqlvcn2.id
  provider = oci.replica
}


data "oci_dns_views" "mysqlvcn1" {
  depends_on = [ oci_core_virtual_network.mysqlvcn1 ]
  compartment_id = var.compartment_ocid
  scope = "PRIVATE"
  display_name = "mysqlvcn1"
  provider = oci.source
}

data "oci_dns_views" "mysqlvcn2" {
  depends_on = [ oci_core_virtual_network.mysqlvcn2 ]
  compartment_id = var.compartment_ocid
  scope = "PRIVATE"
  display_name = "mysqlvcn2"
  provider = oci.replica
}

resource "oci_dns_resolver" "mysqlvcn1" {
 depends_on = [
	oci_core_virtual_network.mysqlvcn1,
	oci_core_virtual_network.mysqlvcn2,
  oci_core_subnet.private1,
  oci_core_subnet.public1,
  oci_core_subnet.private2,
  oci_core_subnet.public2,
 ]

 resolver_id = data.oci_core_vcn_dns_resolver_association.mysqlvcn1.dns_resolver_id
 scope =  "PRIVATE"

 provider = oci.source

}

resource "oci_dns_resolver_endpoint" "mysqlvcn1_forwarder" {
  depends_on = [
    oci_core_virtual_network.mysqlvcn1,
    oci_core_subnet.private1,
   ]
  resolver_id = oci_dns_resolver.mysqlvcn1.id
  is_forwarding = true
  is_listening = false
  name = var.vcn_source_dns_forwarder.name
  subnet_id = oci_core_subnet.private1.id
  forwarding_address = var.vcn_source_dns_forwarder.ip
  scope = "PRIVATE"

  provider = oci.source

}

resource "oci_dns_resolver_endpoint" "mysqlvcn1_listener" {
  depends_on = [
    oci_core_virtual_network.mysqlvcn1,
    oci_core_subnet.private1,
   ]
  resolver_id = oci_dns_resolver.mysqlvcn1.id
  is_forwarding = false
  is_listening = true
  name = var.vcn_source_dns_listener.name
  subnet_id = oci_core_subnet.private1.id
  listening_address = var.vcn_source_dns_listener.ip
  scope = "PRIVATE"

  provider = oci.source

}

#resource "oci_dns_resolver_endpoint" "mysqlvcn1_forwarder_pub" {
#  depends_on = [
#    oci_core_virtual_network.mysqlvcn1,
#    oci_core_subnet.public1,
#   ]
#  resolver_id = oci_dns_resolver.mysqlvcn1.id
#  is_forwarding = true
#  is_listening = false
#  name = var.vcn_source_dns_forwarder_pub.name
#  subnet_id = oci_core_subnet.public1.id
#  forwarding_address = var.vcn_source_dns_forwarder_pub.ip
#  scope = "PRIVATE"
#
#  provider = oci.source
#
#}

resource "oci_dns_resolver_endpoint" "mysqlvcn1_listener_pub" {
  depends_on = [
    oci_core_virtual_network.mysqlvcn1,
    oci_core_subnet.public1,
   ]
  resolver_id = oci_dns_resolver.mysqlvcn1.id
  is_forwarding = false
  is_listening = true
  name = var.vcn_source_dns_listener_pub.name
  subnet_id = oci_core_subnet.public1.id
  listening_address = var.vcn_source_dns_listener_pub.ip
  scope = "PRIVATE"

  provider = oci.source

}


#### Replica DNS Resolver
resource "oci_dns_resolver" "mysqlvcn2" {
 depends_on = [
  oci_core_virtual_network.mysqlvcn1,
  oci_core_virtual_network.mysqlvcn2,
  oci_core_subnet.private1,
  oci_core_subnet.public1,
  oci_core_subnet.private2,
  oci_core_subnet.public2,
 ]
 resolver_id = data.oci_core_vcn_dns_resolver_association.mysqlvcn2.dns_resolver_id
 scope =  "PRIVATE"

 provider = oci.replica
}

resource "oci_dns_resolver_endpoint" "mysqlvcn2_forwarder" {
  depends_on = [
    oci_core_virtual_network.mysqlvcn2,
    oci_core_subnet.private2,
   ]
  resolver_id = oci_dns_resolver.mysqlvcn2.id
  is_forwarding = true
  is_listening = false
  name = var.vcn_replica_dns_forwarder.name
  subnet_id = oci_core_subnet.private2.id
  forwarding_address = var.vcn_replica_dns_forwarder.ip
  scope = "PRIVATE"

  provider = oci.replica
}

resource "oci_dns_resolver_endpoint" "mysqlvcn2_listener" {
  depends_on = [
    oci_core_virtual_network.mysqlvcn2,
    oci_core_subnet.private2,
   ]
  resolver_id = oci_dns_resolver.mysqlvcn2.id
  is_forwarding = false
  is_listening = true
  name = var.vcn_replica_dns_listener.name
  subnet_id = oci_core_subnet.private2.id
  listening_address = var.vcn_replica_dns_listener.ip
  scope = "PRIVATE"

  provider = oci.replica
}

resource "oci_dns_resolver_endpoint" "mysqlvcn2_forwarder_pub" {
  depends_on = [
    oci_core_virtual_network.mysqlvcn2,
    oci_core_subnet.public2,
   ]
  resolver_id = oci_dns_resolver.mysqlvcn2.id
  is_forwarding = true
  is_listening = false
  name = var.vcn_replica_dns_forwarder_pub.name
  subnet_id = oci_core_subnet.public2.id
  forwarding_address = var.vcn_replica_dns_forwarder_pub.ip
  scope = "PRIVATE"

  provider = oci.replica

}

#resource "oci_dns_resolver_endpoint" "mysqlvcn2_listener_pub" {
#  depends_on = [
#    oci_core_virtual_network.mysqlvcn2,
#    oci_core_subnet.public2,
#   ]
#  resolver_id = oci_dns_resolver.mysqlvcn2.id
#  is_forwarding = false
#  is_listening = true
#  name = var.vcn_replica_dns_listener_pub.name
#  subnet_id = oci_core_subnet.public2.id
#  listening_address = var.vcn_replica_dns_listener_pub.ip
#  scope = "PRIVATE"
#
#  provider = oci.replica
#
#}
