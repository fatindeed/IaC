variable "region" {
  type        = string
  description = "OCI region (must be home region for A1 Free)."
  default     = "ap-osaka-1"
}

variable "tenancy_ocid" {
  type        = string
  description = "Tenancy OCID (root compartment)."
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for the ubuntu user."
}
