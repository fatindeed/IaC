resource "oci_identity_compartment" "a1_free" {
  compartment_id = var.tenancy_ocid
  name           = "a1-free-compartment"
  description    = "Always Free A1 VM in Osaka"

  enable_delete = false
}
