#needs to supply: instance count, region, ssh keys, IP of master, terraform init

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
if ! [[ $1 =~ '^[0-9]+$' ]]; then
  echo "Error: Argument should be a number"
	exit 2
fi

inst_count="$1"

#check for existing AWS CLI config to get region; default to us-east-1 if not found
if [ -f ~/.aws/config ]; then
	region="$(cat ~/.aws/config | grep '[default]' -a1 | tail -n1 | awk '{print $3}')"
	if [ "$region" == "" ]; then
		echo "Default region in AWS CLI config is empty, defaulting to us-east-1"
		region="us-east-1"
	fi
fi

#create ssh keypairs if not already there
if ! [ -f to_bastion ]; then
	ssh-keygen -b 2048 -t rsa -f to_bastion -N "" -C "user@terraform-master"
fi
if ! [ -f to_docker ]; then
	ssh-keygen -b 2048 -t rsa -f to_docker -N "" -C "ec2-user@bastion"
fi
bastion_key="$(cat to_bastion.pub)"
docker_key="$(cat to_docker.pub)"

#get IP of master machine (the one running terraform), to allow it access to bastion
master_ip="$(curl -s http://checkip.amazonaws.com)/32"
if [ "$master_ip" == "" ]; then
	master_ip="$(wget -qO- http://checkip.amazonaws.com)/32"
fi
if [ "$master_ip" == "" ]; then
	echo "Failed to get public IP of master, exiting"
	exit 3
fi

#run terraform init to download required plugins
terraform init

#create architecture
terraform plan -var "inst_count=${inst_count}" -var "region_name=${region}" -var "keys={ to_bastion = "$bastion_key", to_docker = "$docker_key" }" -var "master_ip=${master_ip}" -out="plan"
terraform apply plan
