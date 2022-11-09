## Copyright (c) 2021 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

#data "template_file" "key_script" {
#  template = file("${path.module}/scripts/sshkey.tpl")
#  vars = {
#    ssh_public_key = tls_private_key.public_private_key_pair.public_key_openssh
#  }
#}

/*
data "template_cloudinit_config" "cloud_init" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "ainit.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.key_script.rendered
  }
}
*/

resource "oci_core_instance" "instance" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = var.instance_name
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.ocpu
    memory_in_gbs = var.memory
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = var.create_in_private_subnet ? false : true
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ImageOCID.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = var.user_data
  }

  dynamic "agent_config" {
    for_each = var.create_in_private_subnet ? [1] : []
    content {
      are_all_plugins_disabled = false
      is_management_disabled   = false
      is_monitoring_disabled   = false
      plugins_config {
        desired_state = "ENABLED"
        name          = "Bastion"
      }
    }
  }


}
