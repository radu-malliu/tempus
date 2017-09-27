#Defines the AWS provider
#We do not store credentials here, we rely on Terraform's built-in mechanism to retrieve these (AWS CLI config, env variables, instance role)

#As TF doesn't currently support picking up the default region from CLI config, we default to one. We stilltry to get the region from CLI config in the master shell script
variable "region_name" {
	default = "us-east-1"
}

provider "aws" {
	region = "${var.region_name}"
}
