#Defines the VPC for a typical Scenario 2 AWS VPC setup

resource "aws_vpc" "tempus" {
  cidr_block = "10.0.0.0/16"
}

