resource "aws_eip" "ip_ngw" {
  vpc      = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.tempus.id}"
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.ip_ngw.id}"
	subnet_id = "${aws_subnet.public.id}"

  depends_on = ["aws_internet_gateway.igw", "aws_eip.ip_ngw"]
}
