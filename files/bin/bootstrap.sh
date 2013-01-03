#!/bin/bash -e

if [ $(id -u) -ne 0 ];
then
  echo "You must be root to run this script. Exiting."
  exit 1
fi

cd /etc/yum.repos.d
wget http://public-yum.oracle.com/public-yum-el5.repo
rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
yum -y install puppet git

rm -fR /etc/puppet
git clone https://github.com/iteego/puppet.oracle.ova.git /etc/puppet
