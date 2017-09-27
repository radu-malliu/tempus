variable "inst_count" {
	default = "1"
}

variable "azs" {
	default = {
		"0" = "a"
		"1" = "b"
		"2" = "c"
	}
}

resource "aws_instance" "example" {
  count = "${var.inst_count}"
	
	ami           = "ami-9eb4b1e5"
  instance_type = "t2.micro"
	subnet_id = "${aws_subnet.private.id}"
	availability_zone = "us-east-1${lookup(var.azs, count.index % 3)}"
	key_name = "${aws_key_pair.to_docker.key_name}"

  depends_on = ["aws_subnet.private"]

	provisioner "remote-exec" {
    inline = [
      "docker run hello-world"
    ]
  	connection {
    	type     = "ssh"
    	
			user = "ec2-user"
			private_key = "${file("to_docker")}"

			bastion_host = "${aws_instance.bastion.public_ip}"
			bastion_user = "ec2-user"
			bastion_private_key = "${file("to_bastion")}"
  	}	
	}
}
