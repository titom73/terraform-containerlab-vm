module "webserver" {
    source = "../aws-containerlab-vm"

    private_key_path    = var.private_key_path
    public_key_path     = var.public_key_path
    aws_region          = var.aws_region
    availability_zone   = var.availability_zone
    instance_type       = var.instance_type
    project             = var.project
}