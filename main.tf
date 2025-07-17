
locals {
  vcn_id_source = oci_core_virtual_network.mysqlvcn1.id
  internet_gateway_id_source = oci_core_internet_gateway.internet_gateway1.id
  nat_gateway_id_source = oci_core_nat_gateway.nat_gateway1.id
  public_route_table_id_source = oci_core_route_table.public_route_table1.id
  private_route_table_id_source = oci_core_route_table.private_route_table1.id
  private_subnet_id_source = oci_core_subnet.private1.id
  public_subnet_id_source = oci_core_subnet.public1.id
  private_security_list_id_source = oci_core_security_list.private_security_list1.id
  public_security_list_id_source = oci_core_security_list.public_security_list1.id

  vcn_id_replica = oci_core_virtual_network.mysqlvcn2.id
  internet_gateway_id_replica = oci_core_internet_gateway.internet_gateway2.id
  nat_gateway_id_replica = oci_core_nat_gateway.nat_gateway2.id
  public_route_table_id_replica = oci_core_route_table.public_route_table2.id
  private_route_table_id_replica = oci_core_route_table.private_route_table2.id
  private_subnet_id_replica = oci_core_subnet.private2.id
  public_subnet_id_replica = oci_core_subnet.public2.id
  private_security_list_id_replica = oci_core_security_list.private_security_list2.id
  public_security_list_id_replica = oci_core_security_list.public_security_list2.id

  # NEW REGION

  ssh_key = var.ssh_authorized_keys_path == "" ? tls_private_key.public_private_key_pair.public_key_openssh : file(var.ssh_authorized_keys_path)
  ssh_private_key = var.ssh_private_key_path == "" ? tls_private_key.public_private_key_pair.private_key_pem : file(var.ssh_private_key_path)
  private_key_to_show = var.ssh_private_key_path == "" ? local.ssh_private_key : var.ssh_private_key_path


}

data "oci_identity_availability_domains" "ad_source" {
  compartment_id = var.tenancy_ocid
  provider = oci.source
}

data "template_file" "ad_names_source" {
  count    = length(data.oci_identity_availability_domains.ad_source.availability_domains)
  template = lookup(data.oci_identity_availability_domains.ad_source.availability_domains[count.index], "name")
}

data "oci_core_images" "images_for_shape_source" {
    compartment_id = var.compartment_ocid
    operating_system = "Oracle Linux"
    operating_system_version = "9"
    shape = var.node_shape
    sort_by = "TIMECREATED"
    sort_order = "DESC"
    provider = oci.source
}

# NEW REPLICA IMAGE

resource "tls_private_key" "public_private_key_pair" {
  algorithm = "RSA"
}

// Source

resource "oci_core_virtual_network" "mysqlvcn1" {
  cidr_block = var.vcn_cidr_source
  compartment_id = var.compartment_ocid
  display_name = var.vcn_source
  dns_label = "mysqlvcn1"
  provider = oci.source

  #count = var.existing_vcn_ocid_source == "" ? 1 : 0
}


resource "oci_core_internet_gateway" "internet_gateway1" {
  compartment_id = var.compartment_ocid
  display_name = "internet_gateway_1"
  vcn_id = local.vcn_id_source
  provider = oci.source

  #count = var.existing_internet_gateway_ocid_source == "" ? 1 : 0
}


resource "oci_core_nat_gateway" "nat_gateway1" {
  compartment_id = var.compartment_ocid
  vcn_id = local.vcn_id_source
  display_name   = "nat_gateway1"
  provider = oci.source

  #count = var.existing_nat_gateway_ocid_source == "" ? 1 : 0
}


resource "oci_core_route_table" "public_route_table1" {
  compartment_id = var.compartment_ocid
  vcn_id = local.vcn_id_source
  display_name = "RouteTableForMySQLPublic1"
  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = local.internet_gateway_id_source
  }

  route_rules {
        destination       = var.vcn_cidr_replica
        destination_type  = "CIDR_BLOCK"
        network_entity_id = oci_core_drg.mds_drg_source.id
  }

  # NEW REPLICA ROUTE RULES

  provider = oci.source

  #count = var.existing_public_route_table_ocid_source == "" ? 1 : 0
}

resource "oci_core_security_list" "public_security_list1" {
  compartment_id = var.compartment_ocid
  display_name = "Allow Public SSH Connections to Eventual Servers in Public Subnet"
  vcn_id = local.vcn_id_source
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "6"
  }
  ingress_security_rules {
    tcp_options {
      max = 22
      min = 22
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
  ingress_security_rules {
    tcp_options {
      max = 8140
      min = 8140
    }
    protocol = "6"
    source   = "10.0.0.0/8"
  }
  ingress_security_rules  {
    tcp_options  {
      max = 6450
      min = 6446
    }
    protocol = "6"
    source = "0.0.0.0/0"
  }
  ingress_security_rules  {
    udp_options  {
      max = 53
      min = 53
    }
    protocol = 17
    source   = "0.0.0.0/0"
  }
  #count = var.existing_public_security_list_ocid_source == "" ? 1 : 0
}



resource "oci_core_route_table" "private_route_table1" {
  compartment_id = var.compartment_ocid
  vcn_id = local.vcn_id_source
  display_name   = "RouteTableForMySQLPrivate1"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = local.nat_gateway_id_source
  }
  route_rules {
        destination       = var.vcn_cidr_replica
        destination_type  = "CIDR_BLOCK"
        network_entity_id = oci_core_drg.mds_drg_source.id
  }

  # NEW REPLICA ROUTE RULES

  #count = var.existing_private_route_table_ocid_source == "" ? 1 : 0
  provider = oci.source
}

resource "oci_core_security_list" "private_security_list1" {
  compartment_id = var.compartment_ocid
  display_name   = "Private1"
  vcn_id = local.vcn_id_source

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
  ingress_security_rules  {
    protocol = "1"
    source   = var.vcn_cidr_source
  }
  ingress_security_rules  {
    tcp_options  {
      max = 22
      min = 22
    }
    protocol = "6"
    source   = var.vcn_cidr_source
  }
  ingress_security_rules  {
    tcp_options  {
      max = 22
      min = 22
    }
    protocol = "6"
    source   = var.vcn_cidr_replica
  }
  ingress_security_rules  {
    tcp_options  {
      max = 3306
      min = 3306
    }
    protocol = "6"
    source   = var.vcn_cidr_source
  }
  ingress_security_rules  {
    tcp_options  {
      max = 33061
      min = 33060
    }
    protocol = "6"
    source   = var.vcn_cidr_source
  }
  ingress_security_rules  {
    tcp_options  {
      max = 3306
      min = 3306
    }
    protocol = "6"
    source   = var.vcn_cidr_replica
  }
  ingress_security_rules  {
    tcp_options  {
      max = 33061
      min = 33060
    }
    protocol = "6"
    source   = var.vcn_cidr_replica
  }
  ingress_security_rules  {
    tcp_options  {
      max = 6450
      min = 6446
    }
    protocol = "6"
    source = "10.0.0.0/8"
  }

  ingress_security_rules  {
    udp_options  {
      max = 53
      min = 53
    }
    protocol = 17
    source   = "0.0.0.0/0"
  }
  provider = oci.source

  #count = var.existing_private_security_list_ocid_source == "" ? 1 : 0
}

resource "oci_core_subnet" "public1" {
  cidr_block = cidrsubnet(var.vcn_cidr_source, 8, 0)
  display_name = "mysql_public_subnet1"
  compartment_id = var.compartment_ocid
  vcn_id = local.vcn_id_source
  route_table_id = local.public_route_table_id_source
  security_list_ids = [local.public_security_list_id_source]
  dns_label = "mysqlpub1"
  provider = oci.source

  #count = var.existing_public_subnet_ocid_source == "" ? 1 : 0
}

resource "oci_core_subnet" "private1" {
  cidr_block                 = cidrsubnet(var.vcn_cidr_source, 8, 1)
  display_name               = "mysql_private_subnet1"
  compartment_id             = var.compartment_ocid
  vcn_id                     = local.vcn_id_source
  route_table_id             = local.private_route_table_id_source
  security_list_ids          = [local.private_security_list_id_source]
  prohibit_public_ip_on_vnic = "true"
  dns_label                  = "mysqlpriv1"
  provider = oci.source

  #count = var.existing_private_subnet_ocid_source == "" ? 1 : 0

}

module "compute_instances_source" {

  providers = {
    oci = oci.source
  }

  source              = "./modules/compute"
  region              = var.region_map["source"]
  instance_count      = var.region_instance_map["source"]
  compartment_ocid    = var.compartment_ocid
  image_ocid          = var.node_image_id == "" ? data.oci_core_images.images_for_shape_source.images[0].id : var.node_image_id
  shape               = var.node_shape
  subnet_id           = local.private_subnet_id_source
  ssh_authorized_keys = local.ssh_key
  display_name        = "${element(split("-", var.region_map["source"]), 1)}-mysql"

  depends_on = [ module.puppetserver ]

}

module "puppetserver" {

  providers = {
    oci = oci.source
  }

  source              = "./modules/puppetserver"
  region              = var.region_map["source"]
  compartment_ocid    = var.compartment_ocid
  image_ocid          = var.puppet_image_id == "" ? data.oci_core_images.images_for_shape_source.images[0].id : var.puppet_image_id
  shape               = var.puppet_shape
  flex_shape_ocpus    = var.puppet_flex_shape_ocpus
  flex_shape_memory   = var.puppet_flex_shape_memory
  subnet_id           = local.public_subnet_id_source
  ssh_authorized_keys = local.ssh_key
  ssh_private_key     = local.ssh_private_key
  count               = abs(var.puppet_server_count) > 0 ? 1 : 0

  depends_on = [ oci_dns_resolver.mysqlvcn1 ]
}
