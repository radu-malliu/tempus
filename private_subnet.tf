resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.tempus.id}"
  cidr_block = "10.0.1.0/24"

	depends_on = ["aws_vpc.tempus"]
  
	tags {
    Name = "Private"
  }
}

