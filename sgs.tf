#Defines the security groups required to showcase Scenario 2 AWS VPC setup. The public group allows SSH access from the master machine running TF to the bastion host. The private group allows access from the bastion host to all private instances. The groups also allow HTTP and HTTPS outbound access to any destination for all instances (for updates, packages, etc.)

variable "master_ip" {
	default = "0.0.0.0/0"
}

resource "aws_security_group" "public" {
  name        = "public"
  description = "Allow traffic to/from public instance (bastion)"
	vpc_id = "${aws_vpc.tempus.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.master_ip}"]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
	egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
	egress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["10.0.0.0/16"]
  }
}

resource "aws_security_group" "private" {
  name        = "private"
  description = "Allow traffic to/from private instances"
	vpc_id = "${aws_vpc.tempus.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${aws_security_group.public.id}"]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
