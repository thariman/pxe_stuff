#!/usr/bin/env bash

wget http://192.168.0.253/scripts/compute/novarc
source novarc
echo "source novarc">>.bashrc

#Hypervisor
apt-get install -y kvm libvirt-bin pm-utils
wget http://192.168.0.253/scripts/compute/qemu.conf -O /etc/libvirt/qemu.conf
virsh net-destroy default
virsh net-undefine default
wget http://192.168.0.253/scripts/compute/libvirtd.conf -O /etc/libvirt/libvirtd.conf
wget http://192.168.0.253/scripts/compute/libvirt-bin.conf -O /etc/init/libvirt-bin.conf
wget http://192.168.0.253/scripts/compute/libvirt-bin -O /etc/default/libvirt-bin
service libvirt-bin restart

#Nova
apt-get install -y nova-compute-kvm
wget http://192.168.0.253/scripts/compute/api-paste.ini -O /etc/nova/api-paste.ini
wget http://192.168.0.253/scripts/compute/nova-compute.conf -O /etc/nova/nova-compute.conf
wget http://192.168.0.253/scripts/compute/nova.conf -O /etc/nova/nova.conf

service nova-api-metadata restart
service nova-compute restart

#Quantum
apt-get install -y openvswitch-switch
/etc/init.d/openvswitch-switch start
ovs-vsctl add-br br-int

apt-get install -y quantum-plugin-openvswitch-agent
wget http://192.168.0.253/scripts/compute/quantum.conf -O /etc/quantum/quantum.conf
wget http://192.168.0.253/scripts/compute/ovs_quantum_plugin.ini -O /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini
service quantum-plugin-openvswitch-agent restart
