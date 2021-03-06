#!/bin/bash

PID_FILE=/var/run/update.pid

if [ $(id -u) -ne 0 ];
then
  echo "You must be root to run this script ($0). Exiting."
  exit 1
fi

PID=$(cat $PID_FILE 2>/dev/null) || true
if kill -0 $PID &>/dev/null; then
  echo "Another $0 is already running ($PID). Exiting."
  exit 2
fi
echo -n $$ >$PID_FILE

export GIT_SSL_NO_VERIFY=true

echo "$(date): Running update"
cd /etc/puppet
git reset --hard &>/dev/null
git clean -df &>/dev/null
git pull origin master | grep -v From | grep -v FETCH_HEAD | grep -v "Already up-to-date."
puppet apply /etc/puppet/manifests/init.pp
echo "$(date): Update complete"
echo ""
