#!/bin/bash

if [ $(id -u) -ne 0 ];
then
  echo "You must be root to run this script. Exiting."
  exit 1
fi

cd /etc/yum.repos.d
wget http://public-yum.oracle.com/public-yum-el5.repo
rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
yum install puppet git


