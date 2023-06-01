locals {
  public_subnets = {
    public-subnet-1 = {
      cidr = "10.0.11.0/24"
    }
  }
  private_subnets = {
    private-instance-subnet = {
      cidr = "10.0.21.0/24"
    }
    private-db-subnet = {
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

resource "google_compute_network" "private_network" {
  name                            = "${local.prefix}-private-vpc"
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  mtu                             = 1460
  delete_default_routes_on_create = true // IGWルーティングなどのデフォルトルートを削除する
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
  network       = google_compute_network.private_network.id
}

resource "google_compute_global_address" "private_ip_address_allocated_for_private_vpc_connection" {
  name          = "private-ip-address-allocated-for-private-vpc-connection"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.private_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address_allocated_for_private_vpc_connection.name]
}
