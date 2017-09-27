variable "amis" {
	default = {
		"us-east-1" = "ami-a4c7edb2"
  	"us-east-2" = "ami-8a7859ef"
		"us-west-1" = "ami-327f5352"
		"us-west-2" = "ami-6df1e514"
		"ca-central-1" = "ami-a7aa15c3"
		"ap-northeast-1" = "ami-3bd3c45c"
		"ap-northeast-2" = "ami-e21cc38c"
		"ap-southeast-1" = "ami-77af2014"
		"ap-southeast-2" = "ami-10918173"
		"ap-south-1" = "ami-47205e28"
		"cn-northwest-1" = "ami-b6f928db"
		"eu-central-1" = "ami-82be18ed"
		"eu-west-1" = "ami-d7b9a2b1"
		"eu-west-2" = "ami-ed100689"
		"sa-east-1" = "ami-87dab1eb"
	}
}

resource "aws_instance" "bastion" {
	
	ami           = "${lookup(var.amis, var.region_name)}"
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
			agent = "false"
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
			agent = "false"
    }
	}
}
