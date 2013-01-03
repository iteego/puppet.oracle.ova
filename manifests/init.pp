node localhost {

  exec { 'sudoers':
    command => "patch /etc/sudoers </etc/puppet/files/etc/sudoers.patch"
    path    => ["/usr/bin", "/usr/sbin"],
    unless  => "grep wheel /etc/sudoers | grep -q -v '#'"
  }

}
