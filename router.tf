
module "compute_instances_router_source" {

  providers = {
    oci = oci.source
  }

  source              = "./modules/compute"
  region              = var.region_map["source"]
  instance_count      = var.region_router_map["source"]
  compartment_ocid    = var.compartment_ocid
  image_ocid          = var.node_image_id == "" ? data.oci_core_images.images_for_shape_source.images[0].id : var.node_image_id
  shape               = var.node_shape
  subnet_id           = local.public_subnet_id_source
  ssh_authorized_keys = local.ssh_key
  display_name        = "${element(split("-", var.region_map["source"]), 1)}-router"
  assign_public_ip    = true

  depends_on = [ module.compute_instances_source ]

}

module "compute_instances_router_replica" {

  providers = {
    oci = oci.replica
  }

  source              = "./modules/compute"
  region              = var.region_map["replica"]
  instance_count      = var.region_router_map["replica"]
  compartment_ocid    = var.compartment_ocid
  image_ocid          = var.node_image_id == "" ? data.oci_core_images.images_for_shape_replica.images[0].id : var.node_image_id
  shape               = var.node_shape
  subnet_id           = local.public_subnet_id_replica
  ssh_authorized_keys = local.ssh_key
  display_name        = "${element(split("-", var.region_map["replica"]), 1)}-router"
  assign_public_ip    = true

  depends_on = [ module.compute_instances_replica ]

}
