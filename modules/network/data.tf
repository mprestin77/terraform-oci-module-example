data "oci_core_services" "net_services" {
#  count = var.use_existing_vnc ? 0 : 1
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}
