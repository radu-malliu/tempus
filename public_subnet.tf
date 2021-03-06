#Defines the public subnet in a typical Scenario 2 AWS VPC

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.tempus.id}"
  cidr_block = "10.0.0.0/24"
	map_public_ip_on_launch = "true"

	depends_on = ["aws_vpc.tempus"]
  
	tags {
    Name = "Public"
  }
}

