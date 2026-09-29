resource "tls_private_key" "ssh" {
  algorithm = "ED25519"
}

output "ssh_private_key" {
  description = "Shared VM SSH private key in OpenSSH format."
  value       = tls_private_key.ssh.private_key_openssh
  sensitive   = true
}
