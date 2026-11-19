locals {
  # https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt
  tunnel_domains = toset([
    "google.com",
    "googleapis.com",
    "openai.com",
    "chatgpt.com",
    "github.com",
    "raw.githubusercontent.com",
    "x.com",
    "x.ai",
    "twimg.com",
    "grok.com",
    # "dmm.co.jp",
  ])
}

resource "cloudflare_zero_trust_network_hostname_route" "default" {
  for_each   = local.tunnel_domains
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.default.id
  hostname   = each.key
  # comment    = "Route ${each.key} through default tunnel"
}
