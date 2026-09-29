locals {
  vcn_cidr = "10.0.0.0/16"
  pub_cidr = "10.0.1.0/24"
}

resource "oci_core_vcn" "osaka" {
  compartment_id = oci_identity_compartment.sandbox.id
  display_name   = "osaka-vcn"
  cidr_blocks    = [local.vcn_cidr]
  dns_label      = "osaka"
}

resource "oci_core_internet_gateway" "osaka" {
  compartment_id = oci_identity_compartment.sandbox.id
  vcn_id         = oci_core_vcn.osaka.id
  display_name   = "osaka-igw"
  enabled        = true
}

resource "oci_core_route_table" "public" {
  compartment_id = oci_identity_compartment.sandbox.id
  vcn_id         = oci_core_vcn.osaka.id
  display_name   = "osaka-public-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.osaka.id
  }
}

resource "oci_core_security_list" "public" {
  compartment_id = oci_identity_compartment.sandbox.id
  vcn_id         = oci_core_vcn.osaka.id
  display_name   = "osaka-public-seclist"

  # Keep this list empty: all instance traffic rules are managed in nsg.tf.
  # Explicitly attaching it avoids using the VCN's default security list.
}

resource "oci_core_subnet" "public" {
  compartment_id             = oci_identity_compartment.sandbox.id
  vcn_id                     = oci_core_vcn.osaka.id
  display_name               = "osaka-public-subnet"
  cidr_block                 = local.pub_cidr
  dns_label                  = "public"
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.public.id
  security_list_ids          = [oci_core_security_list.public.id]
}
