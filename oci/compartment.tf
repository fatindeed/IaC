resource "oci_identity_compartment" "sandbox" {
  compartment_id = var.tenancy_ocid
  name           = "sandbox"
  description    = "Personal sandbox for Always Free resources only"

  enable_delete = false
}
