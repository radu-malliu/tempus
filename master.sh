#Master shell script for initiating creation of Scenario 2 AWS infrastructure using Terraform
#The script takes one parameter - the number of private Docker instances to be provsioned

usage="$0 number_of_instances_to_provision"
inst_count=""
region=""
bastion_key=""
docker_key=""
master_ip=""

#test if we get exactly one argument
if [ "$#" -ne 1 ]; then
  echo "Illegal number of parameters"
	echo "Usage: ${usage}"
	exit 1
fi

#test if the one argument is a number
re='^[0-9]+$'
if ! [[ $1 =~ $re ]]; then
  echo "Error: Argument should be a number"
	exit 2
fi

inst_count="$1"

#check for existing AWS CLI config to get region; default to us-east-1 if not found
#we do this as TF doesn't pick up default region from CLI config. We also check for region in env var, so we don't override it from CLI config in case it exists
if ! [ -z "$AWS_DEFAULT_REGION" ]; then
	region="$AWS_DEFAULT_REGION"
elif [ -f ~/.aws/config ]; then
	region="$(cat ~/.aws/config | grep '[default]' -a1 | tail -n1 | awk '{print $3}')"
fi
#check that we have a valid region; empty variable if not
region_list="us-east-1 us-east-2 us-west-1 us-west-2 ca-central-1 ap-northeast-1 ap-northeast-2 ap-southeast-1 ap-southeast-2 ap-south-1 cn-northwest-1 eu-central-1 eu-west-1 eu-west-2 sa-east-1"
valid="false"
for item in $region_list
do
	if [ "$region" = "$item" ]; then
		valid="true"
		break
	fi
done
if ! [ "$valid" = "true" ]; then
	region=""
fi
#default to us-east-1 if all else fails
if [ -z "$region" ]; then
	echo "Default region not found as env variable or in AWS CLI config, or invalid region name specified in either. Check AWS_DEFAULT_REGION and CLI config file. Defaulting to us-east-1"
	region="us-east-1"
fi

#create ssh keypairs if not already there
if ! [ -f "to_bastion" ]; then
	ssh-keygen -b 2048 -t rsa -f to_bastion -N "" -C "user@terraform-master"
fi
if ! [ -f "to_docker" ]; then
	ssh-keygen -b 2048 -t rsa -f to_docker -N "" -C "ec2-user@bastion"
fi
bastion_key="$(cat to_bastion.pub)"
docker_key="$(cat to_docker.pub)"

#get IP of master machine (the one running terraform), to allow it access to bastion
#try curl first
master_ip="$(curl -s http://checkip.amazonaws.com)/32"
#try wget in case curl failed (may not be installed)
if [ "$master_ip" == "" ]; then
	master_ip="$(wget -qO- http://checkip.amazonaws.com)/32"
fi
if [ "$master_ip" == "" ]; then
	echo "Failed to get public IP of master, exiting"
	exit 3
fi

#create tfvars file - this will include all variables required by terraform which have not been defined in the .tf files
printf '%s\n' "inst_count = \"${inst_count}\"" "region_name = \"${region}\"" "keys = { to_bastion = \"${bastion_key}\", to_docker = \"${docker_key}\" }" "master_ip = \"${master_ip}\"" >> variables.tfvars

#run terraform init to download required plugins
terraform init

#create architecture
terraform plan -var-file="variables.tfvars" -out="plan"
if [ -f "plan" ]; then
	terraform apply plan
else
	echo "Failed to generate plan, exiting"
	exit 4
fi
