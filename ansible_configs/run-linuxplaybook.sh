ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -u ec2-user --private-key ~/AWS/keys/windows-server-2022-AWS.pem -e "sliverserverip=$1"  -i $1, linux-playbook.yml

