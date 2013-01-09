#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
apt-get install -y mysql-server python-mysqldb
export DEBIAN_FRONTEND=interactive
mysqladmin -u root password password
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf
service mysql restart
mysql -u root -ppassword <<EOF
CREATE DATABASE nova;
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \
IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'192.168.0.1' \
IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'192.168.0.2' \
IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'192.168.0.3' \
IDENTIFIED BY 'password';
CREATE DATABASE cinder;
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' \
IDENTIFIED BY 'password';
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' \
IDENTIFIED BY 'password';
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
IDENTIFIED BY 'password';
CREATE DATABASE quantum;
GRANT ALL PRIVILEGES ON quantum.* TO 'quantum'@'localhost' \
IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON quantum.* TO 'quantum'@'192.168.0.2' \
IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON quantum.* TO 'quantum'@'192.168.0.3' \
IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
EOF
apt-get install -y rabbitmq-server
rabbitmqctl change_password guest password

#keystone
apt-get install -y keystone python-keystone python-keystoneclient
wget http://192.168.0.253/scripts/controller/keystone.conf -O /etc/keystone/keystone.conf
service keystone restart
keystone-manage db_sync
wget http://192.168.0.253/scripts/controller/openrc
source openrc 
echo "source openrc">>.bashrc
wget http://192.168.0.253/scripts/controller/keystone-data.sh
wget http://192.168.0.253/scripts/controller/keystone-endpoints.sh
sh ./keystone-data.sh
sh ./keystone-endpoints.sh
rm keystone-data.sh
rm keystone-endpoints.sh

#glance
apt-get install -y glance glance-api python-glanceclient glance-common

wget http://192.168.0.253/scripts/controller/glance-api.conf -O /etc/glance/glance-api.conf
wget http://192.168.0.253/scripts/controller/glance-registry.conf -O /etc/glance/glance-registry.conf
service glance-api restart && service glance-registry restart
glance-manage db_sync

#nova
apt-get install -y nova-api nova-cert nova-common \
    nova-scheduler python-nova python-novaclient nova-consoleauth novnc \
    nova-novncproxy

wget http://192.168.0.253/scripts/controller/api-paste.ini -O /etc/nova/api-paste.ini
wget http://192.168.0.253/scripts/controller/nova.conf -O /etc/nova/nova.conf
nova-manage db sync
service nova-api restart
service nova-cert restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-novncproxy restart

#Cinder install
apt-get install -y cinder-api cinder-scheduler cinder-volume iscsitarget 
apt-get install -y open-iscsi iscsitarget-dkms python-cinderclient linux-headers-`uname -r`

wget http://192.168.0.253/scripts/controller/targets.conf -O /etc/tgt/targets.conf
sed -i 's/false/true/g' /etc/default/iscsitarget
service iscsitarget start
service open-iscsi start
wget http://192.168.0.253/scripts/controller/cinder.conf -O /etc/cinder/cinder.conf
wget http://192.168.0.253/scripts/controller/cinder-api-paste.ini -O /etc/cinder/api-paste.ini
wget http://192.168.0.253/scripts/controller/fdisk.in
fdisk /dev/sdb < fdisk.in
pvcreate /dev/sdb1
vgcreate cinder-volumes /dev/sdb1
cinder-manage db sync
service cinder-api restart
service cinder-scheduler restart
service cinder-volume restart
rm fdisk.in

#Quantum install
apt-get install -y quantum-server

wget http://192.168.0.253/scripts/controller/quantum.conf -O /etc/quantum/quantum.conf 
wget http://192.168.0.253/scripts/controller/ovs_quantum_plugin.ini -O /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini 
wget http://192.168.0.253/scripts/controller/quantum-api-paste.ini -O /etc/quantum/api-paste.ini 
service quantum-server restart

apt-get install -y apache2 libapache2-mod-wsgi openstack-dashboard \
    memcached python-memcache
