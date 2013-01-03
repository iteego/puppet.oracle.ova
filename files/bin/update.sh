#!/bin/bash -e

if [ $(id -u) -ne 0 ];
then
  echo "You must be root to run this script ($0). Exiting."
  exit 1
fi

export GIT_SSL_NO_VERIFY=true

cd /etc/puppet
git reset --hard
git clean -df
git pull origin master
puppet apply --verbose --debug /etc/puppet/manifests/init.pp
