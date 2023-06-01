resource "google_service_account" "db_client" {
  account_id   = "sa-${local.db_client_instance_name}"
  display_name = "DB Client sa for VM ${local.db_client_instance_name}"
  project      = var.project_name
  description  = "Used by the VM ${local.db_client_instance_name}"
}

resource "google_compute_instance" "db_client" {
  name                      = local.db_client_instance_name
  machine_type              = "e2-micro"
  zone                      = var.zone
  allow_stopping_for_update = true // インスタンス更新時の停止を許可する

  # scheduling {
  #   automatic_restart = true
  # }

  tags = [local.db_client_instance_name]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.private_network.id
    # subnetwork = google_compute_subnetwork.private["private-instance-subnet"].id

    // Ephemeral public IP
    access_config {}
  }

  metadata_startup_script = <<-EOT
  sudo apt-get update -y && \
  sudo apt install locales-all -y && \
  sudo apt-get install postgresql-client -y
  EOT

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.db_client.email
    scopes = ["cloud-platform"]
  }
}
