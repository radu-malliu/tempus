#TODO: add map of amis per region

resource "aws_instance" "bastion" {
	
	ami           = "ami-a4c7edb2"
  instance_type = "t2.micro"
	subnet_id = "${aws_subnet.public.id}"
	key_name = "${aws_key_pair.to_bastion.key_name}"
	vpc_security_group_ids = ["${aws_security_group.public.id}"]

  depends_on = ["aws_subnet.public"]

	provisioner "file" {
  	source      = "to_docker"
  	destination = "~ec2-user/.ssh/to_docker"

  	connection {
    	type     = "ssh"
    	user     = "ec2-user"
    	private_key = "${file("to_bastion")}"
  	}
	}

	provisioner "remote-exec" {
    inline = [
      "chmod 600 ~ec2-user/.ssh/to_docker"
    ]
		connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = "${file("to_bastion")}"
    }
	}
}
