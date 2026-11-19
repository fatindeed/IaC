resource "cloudflare_zero_trust_access_policy" "warp_login" {
  account_id = var.cloudflare_account_id
  name       = "Allow owner only"
  decision   = "allow"

  include = [
    {
      email = {
        email = var.warp_allowed_email
      }
    }
  ]
}

resource "cloudflare_zero_trust_access_application" "warp_login" {
  account_id = var.cloudflare_account_id
  name       = "Warp Login App"
  type       = "warp"

  policies = [
    {
      id         = cloudflare_zero_trust_access_policy.warp_login.id
      precedence = 1
    }
  ]
}
