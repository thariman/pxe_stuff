#!/usr/bin/env bash

wget http://192.168.0.253/scripts/network/novarc
source novarc
echo "source novarc">>.bashrc

apt-get install -y quantum-plugin-openvswitch-agent \
quantum-dhcp-agent quantum-l3-agent

/etc/init.d/openvswitch-switch restart

ovs-vsctl add-br br-int
ovs-vsctl add-br br-ex
ovs-vsctl add-port br-ex eth2
ip link set up br-ex

wget http://192.168.0.253/scripts/network/api-paste.ini -O /etc/quantum/api-paste.ini
wget http://192.168.0.253/scripts/network/l3_agent.ini -O /etc/quantum/l3_agent.ini 
wget http://192.168.0.253/scripts/network/quantum.conf -O /etc/quantum/quantum.conf
wget http://192.168.0.253/scripts/network/ovs_quantum_plugin.ini -O /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini
wget http://192.168.0.253/scripts/network/dhcp_agent.ini -O /etc/quantum/dhcp_agent.ini

service quantum-plugin-openvswitch-agent restart
service quantum-dhcp-agent restart
service quantum-l3-agent restart

quantum net-list
quantum router-list
