resource "cloudflare_zero_trust_device_default_profile" "default" {
  account_id      = var.cloudflare_account_id
  tunnel_protocol = "masque"

  service_mode_v2 = {
    mode = "warp"
  }

  include = [
    {
      # https://ipinfo.io/198.19.255.255
      address     = "198.19.255.255/32"
      description = "Placeholder to enable Split Tunnel Include mode"
    }
  ]
}

import {
  to = cloudflare_zero_trust_device_default_profile.default
  id = var.cloudflare_account_id
}
