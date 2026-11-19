variable "cloudflare_account_id" {
  description = "Cloudflare Account ID."
  type        = string
  nullable    = false
}

# https://dash.cloudflare.com/<account_id>/api-tokens
variable "cloudflare_api_token" {
  description = "Cloudflare API Token used to authenticate the provider."
  type        = string
  sensitive   = true
}

variable "warp_allowed_email" {
  description = "Email address allowed to enroll WARP devices"
  type        = string
}
