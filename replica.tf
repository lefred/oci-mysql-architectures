// Replica

data "oci_core_images" "images_for_shape_replica" {
    compartment_id = var.compartment_ocid
    operating_system = "Oracle Linux"
    operating_system_version = "9"
    shape = var.node_shape
    sort_by = "TIMECREATED"
    sort_order = "DESC"
    provider = oci.replica
}


resource "oci_core_subnet" "public2" {
  cidr_block = cidrsubnet(var.vcn_cidr_replica, 8, 0)
  display_name = "mysql_public_subnet2"
  compartment_id = var.compartment_ocid
  vcn_id = local.vcn_id_replica
  route_table_id = local.public_route_table_id_replica
//  security_list_ids = [local.public_security_list_id_replica]
  dns_label = "mysqlpub2"
  provider = oci.replica

  #count = var.existing_public_subnet_ocid_replica == "" ? 1 : 0
}

data "oci_identity_availability_domains" "ad_replica" {
  compartment_id = var.tenancy_ocid
  provider = oci.replica
}

data "template_file" "ad_names_replica" {
  count    = length(data.oci_identity_availability_domains.ad_replica.availability_domains)
  template = lookup(data.oci_identity_availability_domains.ad_replica.availability_domains[count.index], "name")
}

resource "oci_core_virtual_network" "mysqlvcn2" {
  cidr_block = var.vcn_cidr_replica
  compartment_id = var.compartment_ocid
  display_name = var.vcn_replica
  dns_label = "mysqlvcn2"
  provider = oci.replica

  #count = var.existing_vcn_ocid_replica == "" ? 1 : 0
}


resource "oci_core_internet_gateway" "internet_gateway2" {
  compartment_id = var.compartment_ocid
  display_name = "internet_gateway_2"
  vcn_id = local.vcn_id_replica
  provider = oci.replica

  #count = var.existing_internet_gateway_ocid_replica == "" ? 1 : 0
}


resource "oci_core_nat_gateway" "nat_gateway2" {
  compartment_id = var.compartment_ocid
  vcn_id = local.vcn_id_replica
  display_name   = "nat_gateway2"
  provider = oci.replica

  #count = var.existing_nat_gateway_ocid_replica == "" ? 1 : 0
}


resource "oci_core_route_table" "public_route_table2" {
  compartment_id = var.compartment_ocid
  vcn_id = local.vcn_id_replica
  display_name = "RouteTableForMySQLPublic2"
  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = local.internet_gateway_id_replica
  }
  route_rules {
        destination       = var.vcn_cidr_source
        destination_type  = "CIDR_BLOCK"
        network_entity_id = oci_core_drg.mds_drg_replica.id
  }
  provider = oci.replica

  #count = var.existing_public_route_table_ocid_replica == "" ? 1 : 0
}

resource "oci_core_security_list" "public_security_list2" {
  compartment_id = var.compartment_ocid
  display_name = "Allow Public SSH Connections to Eventual Servers in Public Subnet"
  vcn_id = local.vcn_id_replica
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
  ingress_security_rules  {
    udp_options  {
      max = 53
      min = 53
    }
    protocol = 17
    source   = "0.0.0.0/0"
  }
  ingress_security_rules  {
    tcp_options  {
      max = 6450
      min = 6446
    }
    protocol = "6"
    source = "0.0.0.0/0"
  }

  provider = oci.replica

  #count = var.existing_public_security_list_ocid_replica == "" ? 1 : 0
}

resource "oci_core_route_table" "private_route_table2" {
  compartment_id = var.compartment_ocid
  vcn_id = local.vcn_id_replica
  display_name   = "RouteTableForMySQLPrivate2"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = local.nat_gateway_id_replica
  }
  route_rules {
        destination       = var.vcn_cidr_source
        destination_type  = "CIDR_BLOCK"
        network_entity_id = oci_core_drg.mds_drg_replica.id
  }

  #count = var.existing_private_route_table_ocid_replica == "" ? 1 : 0
  provider = oci.replica
}

resource "oci_core_security_list" "private_security_list2" {
  compartment_id = var.compartment_ocid
  display_name   = "Private2"
  vcn_id = local.vcn_id_replica

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
  ingress_security_rules  {
    protocol = "1"
    source   = var.vcn_cidr_replica
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
    udp_options  {
      max = 53
      min = 53
    }
    protocol = 17
    source   = "0.0.0.0/0"
  }
  ingress_security_rules  {
    tcp_options  {
      max = 6450
      min = 6446
    }
    protocol = "6"
    source = "0.0.0.0/0"
  }

  provider = oci.replica

  #count = var.existing_private_security_list_ocid_replica == "" ? 1 : 0
}

resource "oci_core_subnet" "private2" {
  cidr_block                 = cidrsubnet(var.vcn_cidr_replica, 8, 1)
  display_name               = "mysql_private_subnet2"
  compartment_id             = var.compartment_ocid
  vcn_id                     = local.vcn_id_replica
  route_table_id             = local.private_route_table_id_replica
  security_list_ids          = [local.private_security_list_id_replica]
  prohibit_public_ip_on_vnic = "true"
  dns_label                  = "mysqlpriv2"
  provider = oci.replica

  #count = var.existing_private_subnet_ocid_replica == "" ? 1 : 0

}

module "compute_instances_replica" {

  providers = {
    oci = oci.replica
  }

  source              = "./modules/compute"
  region              = var.region_map["replica"]
  instance_count      = var.region_instance_map["replica"]
  compartment_ocid    = var.compartment_ocid
  image_ocid          = var.node_image_id == "" ? data.oci_core_images.images_for_shape_replica.images[0].id : var.node_image_id
  shape               = var.node_shape
  subnet_id           = local.private_subnet_id_replica
  ssh_authorized_keys = local.ssh_key
  display_name        = "${element(split("-", var.region_map["replica"]), 1)}-mysql"

  depends_on = [ module.puppetserver ]

}

