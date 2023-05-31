terraform {
  required_version = ">= 1.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.6"
    }
  }
}

provider "google" {
  credentials = file(var.credential)
  project     = var.project_name
  region      = var.region
}
