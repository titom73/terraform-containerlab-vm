output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}

output "gcp_region" {
  description = "Region where VM is running on"
  value = var.gcp_az
}

output "ssh_connection" {
  description = "Connection information"
  value = "ssh ubuntu@${google_compute_instance.default.network_interface.0.access_config.0.nat_ip} -i ${var.private_key_path}"
}
