#!/bin/bash

function CreateNewPartition() {
DISK=$1
/sbin/fdisk $DISK<<EOF  
n
p
1


t
8e
wq
EOF
}

function CreateLVM_Partition(){

pvcreate $PARTITION
vgcreate $VGname $PARTITION
lvcreate -l 100%VG -n $LVname $VGname
mkfs.ext4 /dev/$VGname/$LVname
if [ ! -d $MountPoint ];then
        mkdir -p  $MountPoint
    fi
    echo "/dev/$VGname/$LVname     $MountPoint   ext4   defaults 0 0" >> /etc/fstab

    mount -a

    df -h |grep $MountPoint

}

function main() {

DISK=$1            #磁盘名称，例如：/dev/sdc
VGname=$2          #逻辑卷组名称
LVname=$3          #逻辑卷名称
MountPoint=$4      #挂载点


CHECK_EXIST=`/sbin/fdisk -l 2> /dev/null | grep -o "$DISK"`
#[ ! "$CHECK_EXIST" ] && { echo "Error: Disk is not found !"; exit 1;}
if [ ! "$CHECK_EXIST" ];then
        echo "Error: Disk is not found !"
        exit 1
fi

CHECK_PARTITION_EXIST=`/sbin/fdisk -l 2> /dev/null | grep -o "$DISK[1-9]"`

#[ ! "$CHECK_DISK_EXIST" ] || { echo "WARNING: ${CHECK_DISK_EXIST} is Partition already !"; exit 1;}
if [ ! "$CHECK_PARTITION_EXIST" ];then
    CreateNewPartition $DISK
    PARTITION=$DISK[1]
    CreateLVM_Partition 
else
    echo "WARNING: ${CHECK_PARTITION_EXIST} is Partition already !"
    PARTITION=$CHECK_PARTITION_EXIST
    CreateLVM_Partition $PARTITION $VGname $LVname $MountPoint                                    
fi
}
   main $1 $2 $3 $4
