terraform {
  required_version = ">= 1.5.0"

  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    oci = {
      source  = "oracle/oci"
      version = "~> 9.0"
    }
  }

  backend "oci" {}
}

provider "oci" {
  region = var.region
}
