variable "puppet_server_count" {
  description = "Number of Puppet Server instances to create"
  type        = number
  default     = 1
}

variable "region_instance_map" {
  type = map(number)
  description = "Map of region to number of compute instances"
  default = {
    source = 0,
    replica = 0
  }
}

variable "region_router_map" {
  type = map(number)
  description = "Map of region to number of compute router instances"
  default = {
    source = 0,
    replica = 0
  }
}

variable "region_map" {
  type = map(string)
  default = {
    source = "us-ashburn-1"
    replica = "eu-frankfurt-1"
  }
}


variable "tenancy_ocid" {
  description = "Tenancy's OCID"
}

variable "user_ocid" {
  description = "User's OCID"
  default = ""
}

variable "compartment_ocid" {
  description = "Compartment's OCID where VCN will be created. "
}

variable "private_key_path" {
  description = "The private key path to pem. DO NOT FILL WHEN USING RESOURCE MANAGER STACK! "
  default     = ""
}

variable "fingerprint" {
  description = "Key Fingerprint"
  default     = ""
}

variable "dns_label" {
  description = "Allows assignment of DNS hostname when launching an Instance. "
  default     = ""
}

variable "label_prefix" {
  description = "To create unique identifier for multiple setup in a compartment."
  default     = ""
}


# Source Information

variable "region_source" {
  description = "OCI Region for Replication Source"
}

variable "vcn_source" {
  description = "VCN Name for the Source"
  default     = "mysql_vcn_source"
}

variable "vcn_cidr_source" {
  description = "VCN's CIDR IP Block for the Source"
  default     = "10.0.0.0/16"
}

variable "vcn_source_dns_listener" {
  type = object({
    ip   = string
    name = string
  })
  description = "Configuration for VCN DNS source listener"
  default = {
    ip   = "10.0.1.200"
    name = "source_dns_listener"
  }
}

variable "vcn_source_dns_forwarder" {
  type = object({
    ip   = string
    name = string
  })
  description = "Configuration for VCN DNS source forwarder"
  default = {
    ip   = "10.0.1.201"
    name = "source_dns_forwarder"
  }
}


variable "vcn_source_dns_listener_pub" {
  type = object({
    ip   = string
    name = string
  })
  description = "Configuration for VCN DNS source listener Public"
  default = {
    ip   = "10.0.0.200"
    name = "source_dns_listener_pub"
  }
}

variable "vcn_source_dns_forwarder_pub" {
  type = object({
    ip   = string
    name = string
  })
  description = "Configuration for VCN DNS source forwarder Public"
  default = {
    ip   = "10.0.0.201"
    name = "source_dns_forwarder_pub"
  }
}


# Replica Information

variable "region_replica" {
  description = "OCI Region for Replication Replica"
}

variable "vcn_replica" {
  description = "VCN Name for the Replica"
  default     = "mysql_vcn_replica"
}

variable "vcn_cidr_replica" {
  description = "VCN's CIDR IP Block for the Replica"
  default     = "10.1.0.0/16"
}

variable "vcn_replica_dns_listener" {
  type = object({
    ip   = string
    name = string
  })
  description = "Configuration for VCN DNS replica listener"
  default = {
    ip = "10.1.1.200"
    name = "replica_dns_listener"
  }
}

variable "vcn_replica_dns_forwarder" {
  type = object({
    ip   = string
    name = string
  })
  description = "Configuration for VCN DNS replica forwarder"
  default = {
    ip = "10.1.1.201"
    name = "replica_dns_forwarder"
  }
}

variable "vcn_replica_dns_listener_pub" {
  type = object({
    ip   = string
    name = string
  })
  description = "Configuration for VCN DNS replica listener Public"
  default = {
    ip = "10.1.0.200"
    name = "replica_dns_listener_pub"
  }
}

variable "vcn_replica_dns_forwarder_pub" {
  type = object({
    ip   = string
    name = string
  })
  description = "Configuration for VCN DNS replica forwarder Public"
  default = {
    ip = "10.1.0.201"
    name = "replica_dns_forwarder_pub"
  }
}

// Compute instance info

variable "ssh_private_key_path" {
  description = "The private key path to access instance. DO NOT FILL WHEN USING RESOURCE MANAGER STACK!"
  default     = ""
}

variable "ssh_authorized_keys_path" {
  description = "Public SSH keys path to be included in the ~/.ssh/authorized_keys file for the default user on the instance. DO NOT FILL WHEN USING REOSURCE MANAGER STACK!"
  default     = ""
}

variable "node_image_id" {
  description = "The OCID of an image for a node instance to use. "
  default     = ""
}

variable "node_shape" {
  description = "Instance shape to use for master instance. "
  default     = "VM.Standard.E4.Flex"
}

variable "node_flex_shape_ocpus" {
  description = "Flex Instance shape OCPUs"
  default = 1
}

variable "node_flex_shape_memory" {
  description = "Flex Instance shape Memory (GB)"
  default = 8
}

variable "puppet_flex_shape_memory" {
  description = "Flex Instance shape Memory (GB) for Puppet Server"
  default = 8
}

variable "puppet_flex_shape_ocpus" {
  description = "Flex Instance shape OCPUs for Puppet Server"
  default = 4
}

variable "puppet_shape" {
  description = "Instance shape to use for Puppet Server instance. "
  default     = "VM.Standard.E6.Flex"
}

variable "puppet_image_id" {
  description = "The OCID of an image for a Puppet Server instance to use. "
  default     = ""
}
