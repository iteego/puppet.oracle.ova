node localhost {

  exec { 'sudoers':
    command   => 'patch sudoers </etc/puppet/files/etc/sudoers.patch',
    cwd       => '/etc',
    logoutput => true,
    path      => ['/bin', '/usr/bin', '/usr/sbin'],
    unless    => "grep wheel /etc/sudoers | grep -q -v '#'"
  }

}
