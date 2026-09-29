resource "oci_budget_budget" "free_tier_guard" {
  compartment_id         = var.tenancy_ocid
  display_name           = "free-tier-guard"
  amount                 = 1
  reset_period           = "MONTHLY"
  processing_period_type = "MONTH"
  target_type            = "COMPARTMENT"
  targets                = [oci_identity_compartment.sandbox.id]

  description = "Alert if any billable spend appears in sandbox compartment"
}

resource "oci_budget_alert_rule" "actual_100" {
  budget_id      = oci_budget_budget.free_tier_guard.id
  display_name   = "actual-100-percent"
  type           = "ACTUAL"
  threshold      = 100
  threshold_type = "PERCENTAGE"
  recipients     = var.alert_email
  message        = "Actual spend hit 1 SGD in sandbox. Check for non-Always-Free resources."
}

resource "oci_budget_alert_rule" "forecast_80" {
  budget_id      = oci_budget_budget.free_tier_guard.id
  display_name   = "forecast-80-percent"
  type           = "FORECAST"
  threshold      = 80
  threshold_type = "PERCENTAGE"
  recipients     = var.alert_email
  message        = "Projected sandbox spend may exceed Free Tier budget."
}
