#!/usr/bin/env bash

apt-get install ubuntu-cloud-keyring
echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/folsom main">>/etc/apt/sources.list.d/cloud-archive.list
apt-get update && apt-get upgrade
wget --no-proxy http://192.168.0.253/scripts/network/interfaces -O /etc/network/interfaces
wget --no-proxy http://192.168.0.253/scripts/network/sysctl.conf -O /etc/sysctl.conf
wget --no-proxy http://192.168.0.253/scripts/network/hosts -O /etc/hosts
echo "folsom-network">/etc/hostname
apt-get install -y ntp vim
wget --no-proxy http://192.168.0.253/scripts/network/ntp.conf -O /etc/ntp.conf
wget --no-proxy http://192.168.0.253/scripts/network/network.sh -O /home/base/network.sh
wget --no-proxy http://192.168.0.253/scripts/network/quantum-networking.sh -O /home/base/quantum-networking.sh
chmod 755 /home/base/network.sh
chmod 755 /home/base/quantum-networking.sh
