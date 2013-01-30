## License
    iteego/puppet.oracle.ova: puppet manifest repository for setup of 
                              standard oracle db virtualbox appliance.
    
     Copyright 2011-2012 Iteego, Inc.
     Author: Marcus Pemer <marcus@iteego.com>
    
     iteego/puppet.oracle.ova is free software: you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation, either version 3 of the License, or
     (at your option) any later version.
     iteego/puppet.oracle.ova is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.
    
     You should have received a copy of the GNU General Public License
     along with iteego/puppet.oracle.ova.  If not, see <http://www.gnu.org/licenses/>.

## iteego/puppet.oracle.ova

Puppet repository containing system configuration for *Oracle_Developer_Day VirtualBox Appliance*

You can download and install VirtualBox from [here](https://www.virtualbox.org).

You can download the base appliance [here](http://www.oracle.com/technetwork/database/enterprise-edition/databaseappdev-vm-161299.html).

After provisioning your new oracle instance, create a new SCSI controller and attach a new hard drive to that controller (make the size dynamic and set it to, say 100G).

Make sure your appliance has enough RAM allocated for your use case. Also, it would help for you to give your appliance bridged networking, if you want to connect to it from the network.

After this has been done, fire up your appliance, log in as oracle (password oracle) and run the following command in a terminal:

    su - root -c "curl -k https://raw.github.com/iteego/puppet.oracle.ova/master/files/bin/bootstrap.sh | bash"

The command will connect to this repository and then the machine will build itself using puppet.

Once the puppet command completes, you should have oracle up and running, with your added disk formatted and added at /u00. Use standard oracle commands to assign tablespaces under this mount point.
