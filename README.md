# Tempus Project

This repo contains TF config files and a master script, to be used for generating a Scenario 2 AWS VPC setup, along with a number of private instances running Docker and a public instance to be used as a bastion host. Once provisioned, the private Docker instances will run the Hello World Docker container.

To generate the setup, simply run master.sh with a single argument - the number of private Docker instances to spin up in the architecture, e.g.:
./master.sh 2

Note that one additional instance will be created - the bastion host.

Functionality:
The various TF config files define the resources that make up the architecture. SSH keys are used to connect to the instances, these are generated when the setup is created


Assumptions and notes:
- Terraform is installed and on the PATH on the machine where the script is executed
- AWS CLI is installed and configured on the machine where the script is run, or the script is run from an instance with a role that has necessary permissions to create the required resources (vpc, instances, SGs, subnets, key pairs, gateways). This is because login credentials are not requested, relying instead on the Terraform retrieval mechanism.
- The region is not requested, it is picked up from an environment variable (AWS_DEFAULT_REGION) or the AWS CLI default config. If it's not found, or is invalid, it is defaulted to us-east-1.
