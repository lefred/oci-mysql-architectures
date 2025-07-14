#!/bin/bash

sudo dnf install -y curl
curl -O https://yum.puppet.com/puppet8-release-el-9.noarch.rpm
sudo dnf install -y puppet8-release-el-9.noarch.rpm
sudo dnf install -y puppet-agent
sudo dnf update -y openssh-server
sudo systemctl restart sshd

cat <<EOF >> /etc/puppetlabs/puppet/puppet.conf
[main]
server = puppet.mysqlpub1.mysqlvcn1.oraclevcn.com
environment = production
runinterval = 2m
EOF

sudo systemctl start puppet
sudo systemctl enable puppet