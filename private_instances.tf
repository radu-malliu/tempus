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
}
