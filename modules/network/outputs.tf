output "vcn_id" {
	value = var.use_existing_vcn ? var.vcn_id : oci_core_vcn.vcn.0.id
}

output "private_subnet_id" {
	value = var.use_existing_vcn ? var.private_subnet_id : oci_core_subnet.private_subnet.0.id
}

output "public_subnet_id" {
        value = var.use_existing_vcn ? var.public_subnet_id : oci_core_subnet.public_subnet.0.id
}
