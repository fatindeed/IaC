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

  backend "oci" {
    bucket    = "tfstate"
    namespace = "axs8o6eu329a"
    region    = "ap-osaka-1"
    key       = "oci/terraform.tfstate"
  }
}

provider "oci" {
  region = var.region
}
