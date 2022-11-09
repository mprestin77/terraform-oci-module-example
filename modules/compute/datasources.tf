## Copyright (c) 2021 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Get the latest Oracle Linux image
data "oci_core_images" "ImageOCID" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.os
  operating_system_version = var.os_version
  shape                    = var.instance_shape
}

/*
# Get the latest Oracle Linux image
data "oci_core_images" "LinuxImageOCID" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.linux_os
  operating_system_version = var.linux_os_version
  shape                    = "VM.Standard.E4.Flex"
}

# Get the latest Oracle Windows image
data "oci_core_images" "WindowsImageOCID" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.windows_os
  operating_system_version = var.windows_os_version
  shape                    = "VM.Standard.E4.Flex"
}
*/
#data "oci_core_services" "net_services" {
#  filter {
#    name   = "name"
#    values = ["All .* Services In Oracle Services Network"]
#    regex  = true
#  }
#}
