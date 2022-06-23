# create VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.vm_name}-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

# create public subnet
resource "google_compute_subnetwork" "network_subnet" {
  name          = "${var.vm_name}-subnet"
  ip_cidr_range = var.network_subnet_cidr
  network       = google_compute_network.vpc.name
  region        = var.gcp_region
}