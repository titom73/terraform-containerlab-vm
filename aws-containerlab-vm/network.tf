resource "aws_vpc" "prod-vpc" {
    cidr_block = var.cidr_block
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    instance_tenancy = "default"

    tags = {
        Name = var.vm_name
    }
}

resource "aws_subnet" "prod-subnet-public-1" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = var.network_subnet_cidr
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = var.availability_zone

    tags = {
        Name = "subnet-for-${var.vm_name}"
    }
}

# create an IGW (Internet Gateway)
# It enables your vpc to connect to the internet
resource "aws_internet_gateway" "prod-igw" {
    vpc_id = aws_vpc.prod-vpc.id

    tags = {
        Name = "${var.vm_name}-igw"
    }
}

# create a custom route table for public subnets
# public subnets can reach to the internet buy using this
resource "aws_route_table" "prod-public-crt" {
    vpc_id = aws_vpc.prod-vpc.id
    route {
        cidr_block = "0.0.0.0/0" //associated subnet can reach everywhere
        gateway_id = aws_internet_gateway.prod-igw.id //CRT uses this IGW to reach internet
    }

    tags = {
        Name = "${var.vm_name}-public-crt"
    }
}

# route table association for the public subnets
resource "aws_route_table_association" "prod-crta-public-subnet-1" {
    subnet_id = aws_subnet.prod-subnet-public-1.id
    route_table_id = aws_route_table.prod-public-crt.id
}
