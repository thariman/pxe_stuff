#!/usr/bin/env bash

apt-get install ubuntu-cloud-keyring
echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/folsom main">>/etc/apt/sources.list.d/cloud-archive.list
apt-get update && apt-get upgrade
wget --no-proxy http://192.168.0.253/scripts/controller/interfaces -O /etc/network/interfaces
wget --no-proxy http://192.168.0.253/scripts/controller/sysctl.conf -O /etc/sysctl.conf
wget --no-proxy http://192.168.0.253/scripts/controller/hosts -O /etc/hosts
echo "folsom-controller">/etc/hostname
apt-get install -y ntp vim
wget --no-proxy http://192.168.0.253/scripts/controller/ntp.conf -O /etc/ntp.conf
wget --no-proxy http://192.168.0.253/scripts/controller/controller.sh -O /home/base/controller.sh
wget --no-proxy http://192.168.0.253/scripts/controller/importimage.sh -O /home/base/importimage.sh
chmod 755 /home/base/controller.sh
chmod 755 /home/base/importimage.sh
