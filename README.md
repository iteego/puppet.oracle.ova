puppet.oracle.ova
=================

Puppet repository containing system configuration for *Oracle_Developer_Day VirtualBox Appliance*

You can download and install VirtualBox from [here](https://www.virtualbox.org).

You can download the base appliance [here](http://www.oracle.com/technetwork/database/enterprise-edition/databaseappdev-vm-161299.html).

After provisioning your new oracle instance, log in as oracle and run the following command:
    su - root -c "curl -k https://raw.github.com/iteego/puppet.oracle.ova/master/files/bin/bootstrap.sh | bash"

The command will connect to this repository and then the machine will build itself using puppet.

