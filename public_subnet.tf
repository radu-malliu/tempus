resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.tempus.id}"
  cidr_block = "10.0.0.0/24"

	depends_on = ["aws_vpc.tempus"]
  
	tags {
    Name = "Public"
  }
}
