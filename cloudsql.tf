resource "google_sql_database_instance" "main" {
  name             = "private-postgresql"
  region           = var.region
  database_version = "POSTGRES_14"

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = google_compute_network.private_network.id
      enable_private_path_for_google_cloud_services = true
    }
  }

  deletion_protection = false

  depends_on = [google_service_networking_connection.private_vpc_connection]
}
