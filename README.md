# Containerlab in AWS

## Containerlab in AWS

Module path: [aws-containerlab-vm](aws-containerlab-vm/)

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

### Inputs

Module supports a set of inputs, most of them are optional, but 2 are mandatory

__Mandatory variables__

- `public_key_path`: (__Mandatory__) Path to the SSH public key to use for SSH connection to the VM.
- `private_key_path`: (__Mandatory__) Path to the SSH private key to use provisioning the VM from your laptop.

__Optional variables__

- `project`: Name of the project (default: `Containerlab`)
- `cidr_block`: IP range to use to configure VPC. (default: `10.0.0.0/16`)
- `public_subnet` Subnet allocated in `cidr_block` and used to connect VM. (default: `10.1.0.0/24`)
- `instance_type`: Size of the VM running Containerlab. (default: `t2.micro`)
- `aws_region`: In which region to run the topology. (default: `us-east-1`)
- `availability_zone`: Availability zone configured for the stack. (default: `us-east-1a`)
- `ec2_user`: User configured in the VM for running preprovisioning. (default: `ubuntu`)

All these options are described with their default values in the module file [`aws-containerlab-vm/variables.init.tf`](aws-containerlab-vm/variables.init.tf)

### Configure terraform

- Configure shell with your AWS credentials

```bash
# I your bashrc / zshrc
# AWS credentials
export AWS_ACCESS_KEY_ID="....."
export AWS_SECRET_ACCESS_KEY="....."
export AWS_REGION="..."
```

You can find all the different approach to configure terraform and AWS [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#environment-variables)

- Call module in your own stack

```bash
# Create terraform file
tee -a main.tf <<EOF
variable "public_key_path" {
  type        = string
  description = "Path to public key to deploy in EC2 instance"
}

variable "private_key_path" {
  type        = string
  description = "Path to private key to deploy in EC2 instance"
}

module "containerlab" {
    source = "https://github.com/titom73/aws-containerlab-vm"
    private_key_path    = var.private_key_path
    public_key_path     = var.public_key_path
}
EOF
```

- Generate terraform outputs (optional):

```bash
# Create output
tee -a outputs.tf <<EOF
output "aws-region" {
  description = "Region where VM is running on"
  value = "${module.containerlab.aws-region}"
}

output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = "${module.containerlab.instance_public_ip}"
}

output "ssh_connection" {
  description = "Connection information"
  value = "${module.containerlab.ssh_connection}"
}
EOF
```

- Create your own variables:

```bash
# Create tfvars
tee -a terraform.tfvars <<EOF
public_key_path=~/.ssh/id_rsa.pub
private_key_path=~/.ssh/id_rsa
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
module.webserver.aws_key_pair.key-pair: Creating...
module.webserver.aws_vpc.prod-vpc: Creating...
module.webserver.aws_key_pair.key-pair: Creation complete after 0s [id=containerlab-demo-key-pair]
[...]
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

aws-region = "eu-west-3a"
instance_public_ip = "13.38.11.81"
ssh_connection = "ssh ubuntu@13.38.11.81 -i ~/.ssh/id_rsa"
```

> Don't forget to destroy after your tests: `terraform destroy`

## License

Code is under Apache2 License