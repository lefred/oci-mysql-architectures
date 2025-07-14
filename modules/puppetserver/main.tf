
locals {
  puppetserver_cloud_init = file("${path.module}/scripts/install_puppetserver.sh")
}


resource "oci_core_instance" "compute" {

  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  shape               = var.shape

  dynamic "shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.flex_shape_memory
      ocpus = var.flex_shape_ocpus
    }
  }

  source_details {
    source_type = "image"
    source_id   = var.image_ocid
  }

  create_vnic_details {
    assign_public_ip = var.assign_public_ip
    subnet_id        = var.subnet_id
  }


  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
    user_data = base64encode(local.puppetserver_cloud_init)
  }

  display_name = var.display_name
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}



terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
    }
  }
}