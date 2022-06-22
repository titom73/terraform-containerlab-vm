output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.web1.public_ip
}

output "ssh_connection" {
  description = "Connection information"
  value = "ssh ubuntu@${aws_instance.web1.public_ip} -i ${var.private_key_path}"
}

output "aws-region" {
  description = "Region where VM is running on"
  value = "${var.availability_zone}"
}