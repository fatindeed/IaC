resource "cloudflare_zero_trust_tunnel_cloudflared" "default" {
  account_id = var.cloudflare_account_id
  name       = "default"
  config_src = "cloudflare"
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "default" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.default.id
}

output "cloudflared_token" {
  value     = data.cloudflare_zero_trust_tunnel_cloudflared_token.default.token
  sensitive = true
}
