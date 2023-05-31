module "cloudsql-proxy" {
  source  = "appchoose/cloudsql-proxy/google"
  version = "0.1.0"

  project         = var.project_name
  container_image = "eu.gcr.io/cloudsql-docker/gce-proxy:1.32.0"
  instance_name   = local.proxy_instance_name
  container_args = [
    "-instances=${google_sql_database_instance.instance.connection_name}=tcp:0.0.0.0:5432",
    "-enable_iam_login",
  ]

  vm_zone       = var.zone
  vm_subnetwork = google_compute_subnetwork.private["private-instance-subnet"].self_link

  firewall_network       = google_compute_network.private_network.self_link
  firewall_source_ranges = ["0.0.0.0/0"]
}
