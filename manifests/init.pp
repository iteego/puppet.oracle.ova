node localhost {

  exec { 'sudoers':
    command   => "patch /etc/sudoers </etc/puppet/files/etc/sudoers.patch",
    logoutput => true,
    path      => ["/usr/bin", "/usr/sbin"],
    unless    => "grep wheel /etc/sudoers | grep -q -v '#'"
  }

}
