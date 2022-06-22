variable "project" {
  default     = "Containerlab"
  type        = string
  description = "Name of project"
}

variable "cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet" {
  default     = "10.1.0.0/24"
  type        = string
  description = "Public subnet CIDR blocks"
}

variable "instance_type" {
  default     = "t2.micro"
  type        = string
  description = "EC2 VM size"
}

variable "aws_region" {
  default     = "us-east-1"
  type        = string
  description = "Region to use to deploy stack"
}

variable "availability_zone" {
  default     = "us-east-1a"
  type        = string
  description = "AZ to use to deploy stack"
}

variable "public_key_path" {
  type        = string
  description = "Path to public key to deploy in EC2 instance"
}

variable "private_key_path" {
  type        = string
  description = "Path to private key to deploy in EC2 instance"
}

variable "ec2_user" {
  default     = "ubuntu"
  type        = string
  description = "EC2 user"
}