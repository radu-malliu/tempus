#TODO: add map of amis per region

resource "aws_instance" "bastion" {
	
	ami           = "ami-34c0ea22"
  instance_type = "t2.micro"
	subnet_id = "${aws_subnet.public.id}"
	key_name = "${aws_key_pair.to_bastion.key_name}"

  depends_on = ["aws_subnet.public"]
}
