variable "region" {}
variable "instance_count" {}
variable "compartment_ocid" {}
variable "image_ocid" {}
variable "shape" {
  description = "Instance shape to use for master instance. "
  default     = "VM.Standard.E6.Flex"
}

variable "flex_shape_ocpus" {
  description = "Flex Instance shape OCPUs"
  default = 1
}

variable "flex_shape_memory" {
  description = "Flex Instance shape Memory (GB)"
  default = 8
}

variable "subnet_id" {
  description = "The OCID of the Shell subnet to create the VNIC for public access. "
  default     = ""
}

variable "ssh_authorized_keys_path" {
  description = "Public SSH keys path to be included in the ~/.ssh/authorized_keys file for the default user on the instance. DO NOT FILL WHEN USING REOSURCE MANAGER STACK!"
  default     = ""
}

variable "assign_public_ip" {
  description = "Assign public IP to the instance"
  type        = bool
  default     = false
}

variable "ssh_authorized_keys" {
  description = "Public SSH keys path to be included in the ~/.ssh/authorized_keys file for the default user on the instance. "
  default     = ""
}

variable "display_name" {
  description = "The name of the instance."
  default     = "mysql"
}

locals {
  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex",
    "VM.Standard.E5.Flex",
    "VM.Standard.E6.Flex",
    "VM.Standard.A1.Flex",
    "VM.Optimized3.Flex"
  ]
}

locals {
  is_flexible_node_shape = contains(local.compute_flexible_shapes, var.shape)
}
