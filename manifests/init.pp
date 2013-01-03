node localhost {
  
  # See http://docs.puppetlabs.com/references/latest/type.html
  # for type references

  exec { 'enable-wheel-in-sudoers':
    command   => 'patch sudoers </etc/puppet/files/etc/sudoers.patch',
    cwd       => '/etc',
    logoutput => true,
    path      => ['/bin', '/usr/bin', '/usr/sbin'],
    unless    => "grep wheel /etc/sudoers | grep -q -v '#'"
  }

  exec { 'add-la-alias':
    command   => 'echo "alias la=\"ls -la\"" >>/etc/bashrc',
    logoutput => true,
    path      => ['/bin', '/usr/bin', '/usr/sbin'],
    unless    => 'grep -q "alias la=" /etc/bashrc'
  }


  # Install Groovy
  $groovy_version="2.0.6"
  $groovy_root="/usr/groovy"
  $groovy_installer="groovy-binary-$groovy_version.zip"
  $groovy_installer_path="$groovy_root/downloads/$groovy_installer"

  file { 'groovy-root-dir':
    path      => "$groovy_root",
    ensure    => directory,
  }

  file { 'groovy-downloads-dir':
    path      => "$groovy_root/downloads",
    ensure    => directory,
  }

  exec { 'download-groovy':
    command   => "wget -O $groovy_installer_path http://dist.groovy.codehaus.org/distributions/$groovy_installer",
    logoutput => true,
    path      => ['/bin', '/usr/bin', '/usr/sbin'],
    creates   => "$groovy_installer_path",
    require => File['groovy-downloads-dir'],
  }

  exec { 'unpack-groovy-installer':
    command   => "unzip $groovy_installer_path",
    cwd       => "$groovy_root",
    logoutput => true,
    path      => ['/bin', '/usr/bin', '/usr/sbin'],
    creates   => "$groovy_root/groovy-$groovy_version",
    require => Exec['download-groovy'],
  }

  file { 'groovy-home-link':
    ensure    => link,
    path      => "$groovy_root/latest",
    target    => "$groovy_root/groovy-$groovy_version",
    require   => Exec['unpack-groovy-installer'],
  }

  file { '/etc/profile.d/groovy.sh':
    content => "
                 export GROOVY_HOME=$groovy_root/latest
                 export PATH=\$GROOVY_HOME/bin:\$PATH
               ",
  }

  user { 'oracle':
    groups => [
                'davfs2',
                'wheel',
              ],
  }
  
  file { '/etc/profile.d/path.sh':
    content => 'export PATH=/sbin:/usr/sbin:/usr/local/sbin:$PATH',
  }


  # Ensure that our extra disk is built and mounted

  $extra_disk_device='/dev/sda'
  $extra_disk_fs_type='ext4'
  $extra_disk_mount_point='/u00'
  $extra_disk_user='oracle'
  $extra_disk_group='oracle'

  exec { 'mkfs-extra-disk':
    command   => "yes | mkfs -t $extra_disk_fs_type $extra_disk_device",
    logoutput => true,
    path      => ['/bin', '/sbin', '/usr/bin'],
    unless    => "blkid | grep $extra_disk_device | grep -q $extra_disk_fs_type",
  }

  file { 'extra-disk-mount-point':
    ensure    => directory,
    recurse   => true,
    path      => $extra_disk_mount_point,
    owner     => $extra_disk_user,
    group     => $extra_disk_group,
  }

  mount { 'extra-disk-mount':
    ensure    => mounted,
    name      => $extra_disk_mount_point,
    device    => $extra_disk_device,
    fstype    => $extra_disk_fs_type,
    options   => 'defaults',
    remounts  => true,
    atboot    => true,
    require   => [
                   Exec['mkfs-extra-disk'],
                   File['extra-disk-mount-point'],
                ],
  }

  service { 'cron':
    ensure    => running,
  }
  
  cron { 'puppet-update':
    command   => '/etc/puppet/files/bin/update.sh &>>/var/log/puppet/puppet.log',
    minute    => '*',
  }

  file { '/etc/logrotate.d/puppet':
    content =>
'/var/log/puppet/puppet.log {
    missingok
    compress
    rotate 4
    dateext
    notifempty
}',
  }

}
