#!/bin/bash
echo "[Centos]Now you will execulte base enviroment install for GLFS and SMB."

while :
do
echo "Enter number(1~6): "
echo "----------------------------------------------------"
echo "------1 register network ip ------------------------"
echo "------2 close The Firewall -------------------------"
echo "------3 close The Selinux --------------------------"
echo "------4 time Synchronization -----------------------"
echo "------5 install openssl ----------------------------"
echo "------6 setup hostname and ip ----------------------"
echo "------7 Reboot -------------------------------------"
echo "------8 Exit ---------------------------------------"
echo "----------------------------------------------------"

read goto
case $goto in
1)
#vi
echo "set number" >> /etc/virc
#clear content in vi   :.,$d

#register network ip
echo "set static network ip for this machine."
ip addr
echo 

echo "[*]Enter your network card number(eno16777736):"
read net_card_num

echo "[*]Enter static ip address(192.168.x.22):"
read ip_addr

netcfg_path="/etc/sysconfig/network-scripts/ifcfg-${net_card_num}"

echo "change the config of file /etc/sysconfig/network-scripts/ifcfg-${net_card_num}:"

# delete 
sed -i "/BOOTPROTO/d" $netcfg_path > /dev/null
sed -i "/IPADDR/d" $netcfg_path > /dev/null
sed -i "/NETMASK/d" $netcfg_path > /dev/null
sed -i "/GATEWAY/d" $netcfg_path > /dev/null
sed -i "/DNS/d" $netcfg_path > /dev/null

# append
echo "BOOTPROTO='static'" >> $netcfg_path
echo "IPADDR=${ip_addr}" >> $netcfg_path
echo "NETMASK=255.255.255.0" >> $netcfg_path
echo "GATEWAY=0.0.0.0" >> $netcfg_path
echo "DNS=8.8.8.8" >> $netcfg_path

cat $netcfg_path | head -n 22

service network restart

echo "-----------------------------------------------------------------------"
echo "-----------------------------------------------------------------------"
;;

2)
#firewall
echo "0. Close The Firewall."
systemctl stop firewalld.service && systemctl disable firewalld.service
setenforce 0
firewall-cmd --state

##systemctl start firewalld.service && systemctl enable firewalld.service
##firewall-cmd --zone=public --add-port=80/tcp --permannent
##firewall-cmd --zone=public --remove-port=23/tcp --permannent

echo "-----------------------------------------------------------------------"
echo "-----------------------------------------------------------------------"
;;

3)
#selinux
echo "1. Close The Selinux."
echo "SELINUX=disable" >> /etc/selinux/config
echo "add 'SELINUX=disable' to '/etc/selinux/config'."

echo "-----------------------------------------------------------------------"
echo "-----------------------------------------------------------------------"
;;

4)
#time
echo "2. Time Synchronization."
yum install -y ntpdate

echo "[*]Enter the domain name of clock server: "
read ClockServerDomain
if [ $ClockServerDomain = "" ]
then 
	$ClockServerDomain = "ntp1.aliyun.com"
fi

ntpdate $ClockServerDomain
date 

echo "-----------------------------------------------------------------------"
echo "-----------------------------------------------------------------------"
;;

5)
#install openssl
echo "3. Openssl."
yum -y install openssl-devel

echo "-----------------------------------------------------------------------"
echo "-----------------------------------------------------------------------"
;;

6)
#setup hostname and ip
echo "4. Hostname & Ip."

host_name=""
default_name=""
while :
do 
	echo "[*]Enter the host_name: "
	read host_name
	echo "host_name:${host_name}, default_name:${default_name}"
	if [[ $host_name != $default_name ]]
	then
		break
	fi
done

hostnamectl set-hostname $host_name
#su
echo "set host_name:${host_name}"

#network
num_nodes=1
echo "[*]Enter num of nodes:"
read num_nodes

while(( $num_nodes>0 ))
do
	echo "[**]Enter node${num_nodes}'s map'192.168.x.2 node${num_nodes}':"
	read ip_to_node 
	echo $ip_to_node >> /etc/hosts
	echo "----->${ip_to_node} write into /etc/hosts"
	let "num_nodes--"
done

echo "-----------------------------------------------------------------------"
echo "-----------------------------------------------------------------------"
;;

7)
echo "REBOOT[Y/N]:"
read reboot_cd
if [[ $reboot_cd = "Y" || $reboot_cd = "y" ]]
then
	reboot
fi

echo "-----------------------------------------------------------------------"
echo "-----------------------------------------------------------------------"
;;
8)
echo "Exit!"
exit
;;
esac
done
echo "Finished!Next to install GLFS.&SMB"
