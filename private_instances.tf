resource "aws_instance" "example" {
  ami           = "ami-9eb4b1e5"
  instance_type = "t2.micro"
	count = "3"

  depends_on = ["aws_subnet.private"]
}
