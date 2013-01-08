#!/usr/bin/env bash

cd /home/base
apt-get install -y ubuntu-cloud-keyring
echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/folsom main">>/etc/apt/sources.list.d/cloud-archive.list
apt-get update && apt-get upgrade
wget --no-proxy http://192.168.0.253/scripts/compute/interfaces -O /etc/network/interfaces
wget --no-proxy http://192.168.0.253/scripts/compute/sysctl.conf -O /etc/sysctl.conf
wget --no-proxy http://192.168.0.253/scripts/compute/hosts -O /etc/hosts
echo "folsom-compute">/etc/hostname
apt-get install -y ntp vim
wget --no-proxy http://192.168.0.253/scripts/compute/ntp.conf -O /etc/ntp.conf
wget --no-proxy http://192.168.0.253/scripts/compute/compute.sh -O /home/base/compute.sh
chmod 755 /home/base/compute.sh
