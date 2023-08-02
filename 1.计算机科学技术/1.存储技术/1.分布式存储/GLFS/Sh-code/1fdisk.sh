#!/bin/bash

echo "Disk Parition & Mount."
ls /dev/sd*

while :
do
	echo ">>>Select Disk(eg:sdb):"
	read disk_dev

	# print the partition table & write table to disk and exit
	# echo -e "n\np\n\n\n\nw\n" |
	fdisk /dev/${disk_dev} 

	# format
	echo ">>>Enter One Partition of ${disk_dev}(eg:/dev/sdb1):"
	read partition
	mkfs.xfs -f ${partition}

	# create the dir fro partition
	echo ">>>Enter the dir for partition(eg:/data/software):"
	read dir_ptn
	mkdir -p ${dir_ptn}

	# persistence
	echo ">>>Write into /etc/fstab[Y/N]:"
	read w_cont
	if [[ $w_cont = 'Y' || $w_cont = 'y' ]]
	then
		echo "${partition} ${dir_ptn} xfs defaults 0 0" >> /etc/fstab
	fi
	
	echo "------------------------------------------------------"
    echo "--------------Continue Disk Parition[Y/N]-------------"	
	echo "------------------------------------------------------"
	
	read cont
	if [[ $cont != 'Y' && $cont != 'y' ]]
	then
		break
	fi
	
	echo "----------------------------------------------------------"
	echo "----------------------------------------------------------"
	
done

# manual
cat /etc/fstab | tail -n 5
echo "----------------------------------------------------------"
echo "----------------------------------------------------------"
# mount all
mount -a 
echo "----------------------------------------------------------"
echo "----------------------------------------------------------"
df -h
