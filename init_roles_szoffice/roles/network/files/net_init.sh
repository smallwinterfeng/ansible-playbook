#备份网卡配置文件

#NET_NAME=`ifconfig |grep -e "^ens"|awk -F":" '{print $1}'`
#NET_IP=`ifconfig |grep "10.210.110" |awk '{print $2}'`
NET_NAME=`ip add|grep -e "eth[0-9]*" |grep "BROADCAST"|awk '{print $2}'|awk -F: '{print $1}'`
NET_IP=$1

mv /etc/sysconfig/network-scripts/ifcfg-${NET_NAME} /tmp/ifcfg-${NET_NAME}.back
echo > /etc/sysconfig/network-scripts/ifcfg-${NET_NAME}

cat > /etc/sysconfig/network-scripts/ifcfg-${NET_NAME} << EOF
TYPE=Ethernet
BOOTPROTO=none
NAME=${NET_NAME}
DEVICE=${NET_NAME}
ONBOOT=yes
IPADDR=10.210.110.${NET_IP}
NETMASK=255.255.255.0
GATEWAY=10.210.110.1
EOF
cat /etc/sysconfig/network-scripts/ifcfg-${NET_NAME}
