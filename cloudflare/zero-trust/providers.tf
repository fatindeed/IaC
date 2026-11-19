terraform {
  required_version = ">= 1.5.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }

  backend "oci" {
    bucket    = "tfstate"
    namespace = "axs8o6eu329a"
    region    = "ap-osaka-1"
    key       = "cloudflare/zero-trust/terraform.tfstate"
  }
}


provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
