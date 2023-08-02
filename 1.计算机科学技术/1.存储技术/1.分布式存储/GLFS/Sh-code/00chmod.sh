#!/bin/bash

# change the file's permission
chmod +x 0env.sh
chmod +x 1fdisk.sh
chmod +x 2glfs.sh
chmod +x 3volume.sh
chmod +x 4share.sh


# network install glfs
echo "network install glfs."

#yum search centos-release-gluster
#yum install centos-release-gluster9.noarch
#rpm -ql centos-release-gluster9.noarch
#cat /etc/yum.repos.d/CentOS-Gluster-9.repo

yum search centos-release-gluster
yum install centos-release-gluster
yum install -y glusterfs glusterfs-server glusterfs-fuse glusterfs-rdma glusterfs-geo-replication glusterfs-devel