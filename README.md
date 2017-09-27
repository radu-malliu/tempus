# tempus

This repo contains TF config files and a master script, to be used for generating a Scenario 2 AWS VPC setup, along with a number of private instances running Docker and a public instance to be used as a bastion host. Once provisioned, the private Docker instances will run the Hello World Docker container.

To generate the setup, simply run master.sh with a single argument - the number of private Docker instances to spin up in the architecture. Note that one additional instance will be created - the bastion host.

Assumptions:
- AWS CLI is installed and configured on the machine where the script is run, or the script is run from an instance with a role that has necessary permissions. This is because login credentials are not requested, relying on Terraform retrieval mechanism.
- Theregion is not requested, it is picked up from AWS CLI default config, or defaulted to us-east-1
