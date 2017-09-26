variable "region_name" {
	default = "us-east-1"
}

provider "aws" {
	region = "${var.region_name}"
}
