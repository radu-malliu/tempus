#needs to supply: instance count, region, ssh keys, IP of master

ssh-keygen -b 2048 -t rsa -f to_bastion -N "" -C "user@terraform-master"
ssh-keygen -b 2048 -t rsa -f to_docker -N "" -C "ec2-user@bastion"
