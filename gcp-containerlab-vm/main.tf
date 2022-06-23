provider "google" {
  credentials       = file(var.gcp_auth_file)
  project           = var.gcp_project_id
  region            = var.gcp_region
  zone              = var.gcp_az
}

resource "random_id" "instance_id" {
  byte_length       = 8
}

resource "google_compute_instance" "default" {
  # To support more than one VM per stack
  name              = "${var.vm_name}-${random_id.instance_id.hex}"
  instance_type      = var.instance_type
  zone              = var.gcp_az
  tags              = ["ssh", "http"]

  boot_disk {
    initialize_params {
      image         = var.ubuntu_2004_sku
    }
  }

  network_interface {
    network         = google_compute_network.vpc.name
    subnetwork      = google_compute_subnetwork.network_subnet.name
    access_config { }
  }

  metadata = {
    ssh-keys        = "${var.username}:${file(var.public_key_path)}"
  }

  provisioner "remote-exec" {
    script          = "${path.module}/provision-ubuntu.sh"

    connection {
      type          = "ssh"
      host          = self.network_interface.0.access_config.0.nat_ip
      user          = var.username
      private_key   = file(var.private_key_path)
    }
  }
}