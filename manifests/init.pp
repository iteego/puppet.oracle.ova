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
    require => Exec['unpack-groovy-installer'],
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


  exec { 'mkfs-extra-disk':
    command   => "mkfs -t ext4 /dev/hdd",
    logoutput => true,
    path      => ['/bin', '/usr/bin', '/usr/sbin'],
    unless    => "grep -q '/dev/hdd' /etc/mtab",
    notify    => Mount['extra-disk-mount'],
  }

  file { 'extra-disk-mount-point':
    path      => "/u00",
    ensure    => directory,
    owner     => oracle,
    group     => oracle,
  }

  mount { 'extra-disk-mount':
    ensure    => mounted,
    name      => '/u00',
    device    => '/dev/sdd',
    fstype    => 'ext4',
    remounts  => true,
    atboot    => true,
  }
  
}
