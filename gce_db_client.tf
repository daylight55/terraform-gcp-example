resource "google_compute_instance" "db_client" {
  name         = local.db_client_instance_name
  machine_type = "e2-micro"
  zone         = var.zone

  tags = [local.db_client_instance_name]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = <<-EOT
  sudo apt-get update -y && \
  sudo apt-get install postgresql-client -y
  EOT


  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}
