#!/bin/bash

# enable GLFS server

echo "***Enable GLFS server.***"

systemctl start glusterd.service && systemctl enable glusterd.service

#systemctl list-unit-files --type=service

systemctl status glusterd

echo "==========================================="
# Initial the cluster
echo "==========================================="
echo "====Add the other nodes at current node===="
echo "Add Node(0~N) to the Cluster:"
while :
do
	host_name=0
	
	read host_name
	
	if [[ $host_name > 0 ]]
	then
		gluster peer probe "node${host_name}"
	else
		break
	fi
done

echo "==============================================="
gluster peer status
echo "==============================================="
gluster pool list

