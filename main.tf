provider "google" {
  credentials = ""
  project     = "my-project"
  region      = var.region
}

resource "google_compute_instance_template" "osrm_backend" {
  name_prefix = "osrm-backend-template-"
  description = "This template is used to create osrm-backend service instance"

  tags = ["packer-instance"]

  labels = {
    "env"     = "dev"
    "service" = var.base_name
  }

  machine_type   = "e2-standard-4"
  can_ip_forward = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = data.google_compute_image.latest_osrm_backend_image.self_link
    auto_delete  = true
    boot         = true
    disk_size_gb = 30
  }


  network_interface {
    subnetwork = data.google_compute_subnetwork.default_subnetwork.self_link
  }

  metadata_startup_script = var.osrm_startup_script

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "osrm_backend" {
  name = "osrm-backend-group"

  base_instance_name = var.base_name
  region             = var.region

  target_size = 1

  version {
    name              = var.base_name
    instance_template = google_compute_instance_template.osrm_backend.self_link
  }

  named_port {
    name = "tcp"
    port = 5000
  }
}

data "google_compute_image" "latest_osrm_backend_image" {
  family  = "osrm-backend"
  project = "my-project"
}

data "google_compute_subnetwork" "default_subnetwork" {
  name   = "default"
  region = var.region
}
