# Containerlab in GCP

## Overview

This VM is an Ubuntu 20.04 and comes with following tools:

- Docker
- Containerlab
- Git

```bash
ubuntu@ip-10-0-1-143:~$ docker --version
Docker version 20.10.17, build 100c701

ubuntu@ip-10-0-1-143:~$ containerlab version

                           _                   _       _
                 _        (_)                 | |     | |
 ____ ___  ____ | |_  ____ _ ____   ____  ____| | ____| | _
/ ___) _ \|  _ \|  _)/ _  | |  _ \ / _  )/ ___) |/ _  | || \
( (__| |_|| | | | |_( ( | | | | | ( (/ /| |   | ( ( | | |_) )
\____)___/|_| |_|\___)_||_|_|_| |_|\____)_|   |_|\_||_|____/

    version: 0.27.1
     commit: 39860e1c
       date: 2022-06-07T10:45:29Z
     source: https://github.com/srl-labs/containerlab
 rel. notes: https://containerlab.dev/rn/0.27/#0271

ubuntu@ip-10-0-1-143:~$ git --version
git version 2.25.1
```

VM is accessible via port `ssh/22` for management and port `80/http` for graphite instance

### Inputs

Module supports a set of inputs, most of them are optional, but 2 are mandatory

__Mandatory variables__

- `gcp_auth_file`: Authentication file provided by Google Cloud Platform. (Good [documentation](https://linuxhint.com/terraform_google_cloud_platform/) to get it)
- `gcp_project_id`: Your Goolge Project ID
- `public_key_path`: (__Mandatory__) Path to the SSH public key to use for SSH connection to the VM.
- `private_key_path`: (__Mandatory__) Path to the SSH private key to use provisioning the VM from your laptop.

__Optional variables__

- `gcp_region`: Region where the VM will be configured. (default: `europe-west-9`)
- `gcp_az`: AZ where the VM will be configured. (default: `europe-west-9a`)
- `instance_type`: Size of the VM running Containerlab. (default: `e2-standard-8`)
- `vm_name`: Name of the VM and VPC to configure in GCP.
- `network_subnet_cidr`: Subnet IP address to create in VPC.

All these options are described with their default values in the module file [`gcp-containerlab-vm/variables.init.tf`](gcp-containerlab-vm/variables.init.tf)

### Outputs

Module provides some output informations:

- `gcp_region`: Which region VM is running
- `instance_public_ip`: Public IP address of the VM
- `ssh_connection`: Command to run to connect to the VM using SSH

### Configure terraform



- Call module in your own stack

```bash
# Create terraform file
tee -a main.tf <<EOF
variable "gcp_project_id" {
  type          = string
  description   = "The project indicates the default GCP project all of your resources will be created in"
}

variable "gcp_auth_file" {
  type          = string
  description   = "GCP authentication file"
}

variable "public_key_path" {
  type        = string
  description = "Path to public key to deploy in GCP instance"
}

variable "private_key_path" {
  type        = string
  description = "Path to private key to use to connect to GCP instance"
}

module "containerlab" {
    source = "git::https://github.com/titom73/terraform-containerlab-vm.git//gcp-containerlab-vm/"
    gcp_auth_file        = var.gcp_auth_file
    gcp_project_id      = var.gcp_project_id
    public_key_path     = var.public_key_path
    private_key_path     = var.private_key_path
}
EOF
```

- Generate terraform outputs (optional):

```bash
# Create output
tee -a outputs.tf <<EOF
output "instance_public_ip" {
  description = "Public IP of GCP instance"
  value       = module.webserver.instance_public_ip
}

output "gcp_region" {
  description = "Region where VM is running on"
  value = var.gcp_az
}

output "ssh_connection" {
  description = "Connection information"
  value = "${module.webserver.ssh_connection}"
}
EOF
```

- Create your own variables:

```bash
# Create tfvars
tee -a terraform.tfvars <<EOF
gcp_auth_file         = "~/.zshrc-inetsix/gcloud-inetsix-arista.json"
gcp_project_id       = "inetsix"
public_key_path      = "~/.ssh/id-tom-aws.pub"
private_key_path     = "~/.ssh/id-tom-aws"
EOF
```

> Be sure to edit tfvars file to hit your setup.

### Execute terraform

```bash
# Init terraform for the first time
$ terraform init

# Plan for the first run only
$ terraform plan

# Build and deploy
$ terraform deploy

[...]
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

gcp_region = "europe-west9-a"
instance_public_ip = "34.155.52.184"
ssh_connection = "ssh ubuntu@34.155.52.184 -i ~/.ssh/id-tom-aws"
```

> Don't forget to destroy after your tests: `terraform destroy`

