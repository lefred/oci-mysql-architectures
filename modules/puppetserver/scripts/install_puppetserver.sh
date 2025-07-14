#!/bin/bash

dnf install -y curl
curl -O https://yum.puppet.com/puppet8-release-el-9.noarch.rpm
dnf install -y puppet8-release-el-9.noarch.rpm
dnf install -y puppet-agent puppetserver
dnf install -y git
dnf update -y openssh-server
systemctl restart sshd
cd /etc/puppetlabs/code/environments/
rm -rf production
git clone https://github.com/lefred/oci-puppet-demo.git production

sleep 10
cat <<EOF >> /etc/puppetlabs/puppet/puppet.conf
[main]
server = puppet.mysqlpub1.mysqlvcn1.oraclevcn.com
environment = production
runinterval = 2m
[master]
auto_sign = true
EOF

cat <<EOF > /etc/puppetlabs/puppet/autosign.conf
*.oraclevcn.com
EOF

puppetserver ca setup
systemctl start puppetserver
systemctl start puppet
systemctl enable puppet
systemctl enable puppetserver
firewall-cmd --zone=public --permanent --add-port=8140/tcp
firewall-cmd --reload