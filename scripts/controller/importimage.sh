#!/usr/bin/env bash

glance image-create \
    --location http://uec-images.ubuntu.com/releases/12.04/release/ubuntu-12.04-server-cloudimg-amd64-disk1.img \
    --is-public true --disk-format qcow2 --container-format bare --name "Ubuntu"
glance image-list
