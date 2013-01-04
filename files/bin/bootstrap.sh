#!/bin/bash -e

# The purpose of this script is bring the machine up to a point where:
#  - git and puppet are installed
#  - puppet git repo is checked out into /etc/puppet
#  - puppet apply is triggered (update.sh)
#
# Important to note that absolutely nothing else should be done in this script.
# The rest should be contained in the puppet manifests.
#

if [ $(id -u) -ne 0 ];
then
  echo "You must be root to run this script ($0). Exiting."
  exit 1
fi

export GIT_SSL_NO_VERIFY=true

cd /etc/yum.repos.d
wget http://public-yum.oracle.com/public-yum-el5.repo
rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
yum -y install puppet git

rm -fR /etc/puppet
git clone https://github.com/iteego/puppet.oracle.ova.git /etc/puppet

/etc/puppet/files/bin/update.sh
