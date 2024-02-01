## Copyright (c) 2021 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}

data "oci_identity_availability_domain" "ad" {
          compartment_id = "${var.tenancy_ocid}"
          ad_number      = 1
}

# If attach to existing VCN set use_existing_vcn = true and set vcn_id, public_subnet_id and private_subnet_id values

variable "use_existing_vcn" {
  default = false
}

variable "vcn_id" {
  default = ""
}

variable "public_subnet_id" {
  default = ""
}

variable "private_subnet_id" {
  default = ""
}

# If create a new VCN set vcn CIDR, public and private subnets CIDR

variable "network_params" {
  type = map(string)
  default = {
    vcn_cidr = "10.0.0.0/16"
    public_subnet_cidr = "10.0.100.0/24"
    private_subnet_cidr = "10.0.1.0/24"
    vcn_name  = "demovcn"
    vcn_dns_label  = "demovcn"
  }
}

variable "instance1" {
  type = map(string)
  default = {
    name = "jump-server"
    shape = "VM.Standard.E4.Flex"
    ocpu = 1
    memory = 10
    os = "Oracle Linux"
    os_version = "8"
    create_in_private_subnet = false
    num_instances = 1
  }
}

variable "instance2" {
  type = map(string)
  default = {
    name = "app-server"
    shape = "VM.Standard.E4.Flex"
    ocpu = 1
    memory = 10
    os = "Oracle Linux"
    os_version = "8"
    create_in_private_subnet = true
    num_instances = 2
  }
}

variable "instance3" {
  type = map(string)
  default = {
    name = "win-server"
    shape = "VM.Standard.E4.Flex"
    ocpu = 1
    memory = 10
    os = "Windows"
    os_version = "Server 2019 Standard"
    create_in_private_subnet = true
    num_instances = 1
  }
}

variable "create_bastion" {
  default = false
}


locals {
  availability_domain_name    = data.oci_identity_availability_domain.ad.name
}
