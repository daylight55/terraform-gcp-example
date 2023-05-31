locals {
  public_subnets = {
    public-subnet-1 = {
      cidr = "10.0.11.0/24"
    }
  }
  private_subnets = {
    private-subnet-1 = {
      cidr = "10.0.21.0/24"
    }
    private-subnet-2 = {
      cidr = "10.0.22.0/24"
    }
  }
}

resource "google_compute_network" "vpc" {
  name                    = "${local.prefix}-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  mtu                     = 1460
}

resource "google_compute_subnetwork" "public" {
  for_each = local.public_subnets

  name          = "${local.prefix}-${each.key}"
  ip_cidr_range = each.value.cidr
  network       = google_compute_network.vpc.id
}

resource "google_compute_subnetwork" "private" {
  for_each = local.private_subnets

  name          = "${local.prefix}-${each.key}"
  ip_cidr_range = each.value.cidr
  network       = google_compute_network.vpc.id
}
