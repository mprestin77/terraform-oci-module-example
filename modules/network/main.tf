## Copyright (c) 2021 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_vcn" "vcn" {
  count          = var.use_existing_vcn ? 0 : 1
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = var.vcn_name
  dns_label      = var.vcn_dns_label
}

resource "oci_core_internet_gateway" "internet_gateway" {
  count          = var.use_existing_vcn ? 0 : 1
  compartment_id = var.compartment_ocid
  display_name   = "IGW"
  vcn_id         = var.use_existing_vcn ? var.vcn_id : oci_core_vcn.vcn[0].id
}

resource "oci_core_nat_gateway" "nat_gateway" {
  count          = var.use_existing_vcn ? 0 : 1
  compartment_id = var.compartment_ocid
  display_name   = "NATGW"
  vcn_id         = var.use_existing_vcn ? var.vcn_id : oci_core_vcn.vcn[0].id
}

resource "oci_core_service_gateway" "service_gateway" {
  count = var.use_existing_vcn ? 0 : 1
  compartment_id = var.compartment_ocid
  display_name   = "SVCGW"
  services {
      service_id = data.oci_core_services.net_services.services[0]["id"]
  }
  vcn_id         = var.use_existing_vcn ? var.vcn_id : oci_core_vcn.vcn[0].id
}

resource "oci_core_route_table" "public_subnet_route_table" {
  count          = var.use_existing_vcn ? 0 : 1
  compartment_id = var.compartment_ocid
  vcn_id         = var.use_existing_vcn ? var.vcn_id : oci_core_vcn.vcn[0].id
  display_name   = "PublicSubnetRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway[count.index].id
  }
}

resource "oci_core_route_table" "private_subnet_route_table" {
  count          = var.use_existing_vcn ? 0 : 1
  compartment_id = var.compartment_ocid
  vcn_id         = var.use_existing_vcn ? var.vcn_id : oci_core_vcn.vcn[0].id
  display_name   = "PrivateSubnetRouteTable"

  route_rules {
      destination       = data.oci_core_services.net_services.services[0]["cidr_block"]
      destination_type  = "SERVICE_CIDR_BLOCK"
      network_entity_id = oci_core_service_gateway.service_gateway.*.id[count.index]
  }

  route_rules {
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = oci_core_nat_gateway.nat_gateway.*.id[count.index]
  }
}

resource "oci_core_security_list" "public_subnet_securitylist" {
  count          = var.use_existing_vcn ? 0 : 1
  compartment_id = var.compartment_ocid
  vcn_id         = var.use_existing_vcn ? var.vcn_id : oci_core_vcn.vcn[0].id
  display_name   = "PublicSubnetSecurityList"

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }

}

resource "oci_core_security_list" "private_subnet_securitylist" {
  count          = var.use_existing_vcn ? 0 : 1
  compartment_id = var.compartment_ocid
  vcn_id         = var.use_existing_vcn ? var.vcn_id : oci_core_vcn.vcn[0].id
  display_name   = "PrivateSubnetSecurityList"

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "3389"
      min = "3389"
    }
  }
}

resource "oci_core_subnet" "public_subnet" {
  count                      = var.use_existing_vcn ? 0 : 1
  cidr_block                 = var.public_subnet_cidr
  display_name               = "PublicSubnet"
  dns_label                  = "publicsubnet"
  security_list_ids          = [oci_core_security_list.public_subnet_securitylist[0].id]
  compartment_id             = var.compartment_ocid
  vcn_id                     = var.use_existing_vcn ? var.vcn_id : oci_core_vcn.vcn[0].id
  route_table_id             = oci_core_route_table.public_subnet_route_table[0].id
  dhcp_options_id            = oci_core_vcn.vcn[0].default_dhcp_options_id
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_subnet" "private_subnet" {
  count                      = var.use_existing_vcn ? 0 : 1
  cidr_block                 = var.private_subnet_cidr
  display_name               = "PrivateSubnet"
  dns_label                  = "privatesubnet"
  security_list_ids          = [oci_core_security_list.private_subnet_securitylist[0].id]
  compartment_id             = var.compartment_ocid
  vcn_id                     = var.use_existing_vcn ? var.vcn_id : oci_core_vcn.vcn[0].id
  route_table_id             = oci_core_route_table.private_subnet_route_table[0].id
  dhcp_options_id            = oci_core_vcn.vcn[0].default_dhcp_options_id
  prohibit_public_ip_on_vnic = true
}

