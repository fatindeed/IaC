locals {
  instance_a1 = try(values(oci_core_instance.a1)[0], null)
}

output "instance_public_ip" {
  value = local.instance_a1.public_ip
}

output "ssh_command" {
  value = "ssh ubuntu@${local.instance_a1.public_ip}"
}
