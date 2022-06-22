provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_instance" "web1" {
    ami = "${data.aws_ami.ubuntu-linux-2004.id}"
    instance_type = "${var.instance_type}"

    # Subnet ID and tight to a VPC
    subnet_id = "${aws_subnet.prod-subnet-public-1.id}"

    # Security Group
    vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]

    # the Public SSH key
    key_name = "${aws_key_pair.key-pair.id}"

    connection {
        type     = "ssh"
        user     = "ubuntu"
        private_key = "${file(var.private_key_path)}"
        host     = "${self.public_ip}"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo bash -c \"$(curl http://www.packetanglers.com/installdocker.sh)\"",
            "sudo bash -c \"$(curl -sL https://get-clab.srlinux.dev)\"",
            "sudo usermod -aG docker ubuntu",
            "sudo apt-get update && sudo apt-get install -y git"
        ]
    }
}