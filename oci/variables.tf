variable "region" {
  type        = string
  description = "OCI region (must be home region for A1 Free)."
  default     = "ap-osaka-1"
}

variable "tenancy_ocid" {
  type        = string
  description = "Tenancy OCID (root compartment)."
}

variable "a1_count" {
  description = "A1 instance count; shares 2 OCPUs / 12 GB across all A1 instances."
  type        = number
  default     = 0
  nullable    = false
  validation {
    condition     = contains([0, 1, 2], var.a1_count)
    error_message = "a1_count must be 0, 1 or 2."
  }
}

variable "e2_count" {
  description = "Number of VM.Standard.E2.1.Micro instances."
  type        = number
  default     = 0
  nullable    = false
  validation {
    condition     = contains([0, 1, 2], var.e2_count)
    error_message = "e2_count must be 0, 1 or 2."
  }
}

variable "alert_email" {
  type        = string
  description = "Email address for budget alerts"
}
