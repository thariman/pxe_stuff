#!/usr/bin/env bash

scp /etc/libvirt/qemu.conf thariman@192.168.0.253:scripts/compute/.
scp /etc/libvirt/libvirtd.conf thariman@192.168.0.253:scripts/compute/.
scp /etc/init/libvirt-bin.conf thariman@192.168.0.253:scripts/compute/.
scp /etc/default/libvirt-bin thariman@192.168.0.253:scripts/compute/.
scp /etc/nova/api-paste.ini thariman@192.168.0.253:scripts/compute/.
scp /etc/nova/nova-compute.conf thariman@192.168.0.253:scripts/compute/.
scp /etc/nova/nova.conf thariman@192.168.0.253:scripts/compute/.
scp /etc/quantum/quantum.conf thariman@192.168.0.253:scripts/compute/.
scp /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini thariman@192.168.0.253:scripts/compute/.
