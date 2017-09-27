#Defines SSH key pairs required for accessing instances.
#Separate key pairs are used for the bastion host and the private Docker instances

variable "keys" {
	default = {
		"to_bastion" = ""
		"to_docker" = ""
	}
}

resource "aws_key_pair" "to_bastion" {
  key_name   = "to_bastion"
  public_key = "${var.keys["to_bastion"]}"
}

resource "aws_key_pair" "to_docker" {
  key_name   = "to_docker"
  public_key = "${var.keys["to_docker"]}"
}
