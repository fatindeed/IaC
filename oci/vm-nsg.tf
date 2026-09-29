resource "oci_core_network_security_group" "vm_default" {
  compartment_id = oci_identity_compartment.sandbox.id
  vcn_id         = oci_core_vcn.osaka.id
  display_name   = "vm-default-nsg"
}

resource "oci_core_network_security_group_security_rule" "ssh" {
  for_each = toset([
    "139.226.100.182/32", # Shanghai Office
    "183.195.28.0/22",    # James Home
  ])

  network_security_group_id = oci_core_network_security_group.vm_default.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = each.key

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

# resource "oci_core_network_security_group_security_rule" "http" {
#   network_security_group_id = oci_core_network_security_group.vm_default.id
#   direction                 = "INGRESS"
#   protocol                  = "6"
#   source                    = "0.0.0.0/0"

#   tcp_options {
#     destination_port_range {
#       min = 80
#       max = 80
#     }
#   }
# }

# resource "oci_core_network_security_group_security_rule" "https" {
#   network_security_group_id = oci_core_network_security_group.vm_default.id
#   direction                 = "INGRESS"
#   protocol                  = "6"
#   source                    = "0.0.0.0/0"

#   tcp_options {
#     destination_port_range {
#       min = 443
#       max = 443
#     }
#   }
# }

resource "oci_core_network_security_group_security_rule" "egress_all" {
  network_security_group_id = oci_core_network_security_group.vm_default.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
}
