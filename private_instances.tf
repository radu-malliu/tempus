#Defines the private Docker instances to be provisioned. We provision these as private to showcase the Scenario 2 AWS VPC setup

variable "inst_count" {
	default = "1"
}

resource "aws_instance" "example" {
  count = "${var.inst_count}"
	
	ami           = "${lookup(var.amis, var.region_name)}"
  instance_type = "t2.micro"
	subnet_id = "${aws_subnet.private.id}"
	key_name = "${aws_key_pair.to_docker.key_name}"
	vpc_security_group_ids = ["${aws_security_group.private.id}"]

  depends_on = ["aws_subnet.private", "aws_nat_gateway.ngw"]

	provisioner "remote-exec" {
    inline = [
			"sudo yum update -y",
			"sudo yum install -y docker",
      "sudo service docker start",
			"sudo docker run hello-world"
    ]
  	connection {
    	type     = "ssh"
    	
			user = "ec2-user"
			private_key = "${file("to_docker")}"
			agent = "false"

			bastion_host = "${aws_instance.bastion.public_ip}"
			bastion_user = "ec2-user"
			bastion_private_key = "${file("to_bastion")}"
  	}	
	}
}
