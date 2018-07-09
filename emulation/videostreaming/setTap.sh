#!/bin/bash

if [[ $# < 2 ]];
then
echo "arguments: device address"
else
DEV=$1
ADDR=$2
sudo ip tuntap add mode tap dev $DEV
sudo ip addr add $ADDR/24 dev $DEV  # give it an ip
sudo ip link set dev $DEV up  # bring the if up
ip route get $ADDR  # check that packets to 10.0.0.x are going through tun0
echo ping 10.0.0.1  # leave this running in another shell to be able to see the effect of the next example
fi
