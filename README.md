# Containerlab in Cloud

Ths repository provides Terraform modules to create a preprovisioned VM with docker, git and Containerlab in different cloud providers

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

## Supported Clouds

- Amazon AWS with EC2 instance: [aws-containerlab-vm](aws-containerlab-vm/)
- Google Cloud Platform with Compute Instance [gcp-containerlab-vm](gcp-containerlab-vm/)

## Getting Started

Go to the folder for your Cloud provider, update `tfvars` file with your own information and run terraform

```bash
# Move to cloud folder
cd examples/aws/

# Update vars accordingly
vim terraform.tfvars

# Init Terraform
terraform init

# Plan your deployment
terraform plan

# Deploy your stack
terraform deploy

# After your lab is finished, destroy
terraform destroy
```

> This getting started is only for testing and in case you want to use these modules, it is recommended to use module references as described in the [terraform documentation](https://www.terraform.io/language/modules).

## License

Code is under Apache2 License