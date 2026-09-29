locals {
  # Always Free limits checked 2026-09-29:
  # https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm
  # These limits are tenancy-wide: other instances, disks and monthly usage
  # also consume the allowance. This configuration cannot cap account billing.
  instance_shapes = {
    a1 = "VM.Standard.A1.Flex"
    e2 = "VM.Standard.E2.1.Micro"
  }
  instance_counts = { a1 = var.a1_count, e2 = var.e2_count }
  instances = merge([
    for kind, count in local.instance_counts : {
      for index in range(count) : "${kind}-${index + 1}" => kind
    }
  ]...)
  enabled_shapes = {
    for kind, shape in local.instance_shapes : kind => shape
    if local.instance_counts[kind] > 0
  }
  boot_volume_size_in_gbs = 50 # Four instances use at most 200 GB.
}

data "oci_identity_region_subscriptions" "tenancy" {
  tenancy_id = var.tenancy_ocid
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Micro may only be offered in one AD. Never fall back to a paid shape.
data "oci_core_shapes" "available" {
  for_each = length(local.instances) > 0 ? toset([
    for ad in data.oci_identity_availability_domains.ads.availability_domains : ad.name
  ]) : toset([])
  compartment_id      = var.tenancy_ocid
  availability_domain = each.key
}

locals {
  shape_domains = {
    for kind, shape in local.enabled_shapes : kind => [
      for ad in data.oci_identity_availability_domains.ads.availability_domains : ad.name
      if contains([for item in data.oci_core_shapes.available[ad.name].shapes : item.name], shape)
    ]
  }
}

data "oci_core_images" "ubuntu" {
  for_each = local.enabled_shapes

  compartment_id           = oci_identity_compartment.sandbox.id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "26.04"
  shape                    = each.value
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "free" {
  for_each = local.instances

  compartment_id      = oci_identity_compartment.sandbox.id
  availability_domain = try(local.shape_domains[each.value][0], null)
  display_name        = each.key
  shape               = local.instance_shapes[each.value]

  dynamic "shape_config" {
    for_each = each.value == "a1" ? [true] : []
    content {
      ocpus         = 2 / max(var.a1_count, 1)
      memory_in_gbs = 12 / max(var.a1_count, 1)
    }
  }

  source_details {
    source_type             = "image"
    source_id               = try(data.oci_core_images.ubuntu[each.value].images[0].id, null)
    boot_volume_size_in_gbs = local.boot_volume_size_in_gbs
    boot_volume_vpus_per_gb = 10 # Balanced performance.
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public.id
    assign_public_ip = true
    nsg_ids          = [oci_core_network_security_group.vm_default.id]
    display_name     = each.key
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.ssh.public_key_openssh
    user_data           = filebase64("${path.module}/cloud-init.sh")
  }

  preserve_boot_volume = false

  lifecycle {
    precondition {
      condition = contains([
        for region in data.oci_identity_region_subscriptions.tenancy.region_subscriptions : region.region_name
        if region.is_home_region
      ], var.region)
      error_message = "Always Free instances and boot volumes require the tenancy home region."
    }
    precondition {
      condition     = length(local.instances) * local.boot_volume_size_in_gbs <= 200
      error_message = "Combined boot volumes must not exceed the 200 GB Always Free allowance."
    }
    precondition {
      condition     = length(local.shape_domains[each.value]) > 0
      error_message = "The requested Always Free shape is unavailable in this region."
    }
    precondition {
      condition     = length(data.oci_core_images.ubuntu[each.value].images) > 0
      error_message = "No compatible Ubuntu 26.04 image was found for the requested shape."
    }
  }
}

output "instance_public_ip" {
  value = { for name, vm in oci_core_instance.free : name => vm.public_ip }
}
