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

  user { 'oracle':
    groups => [
                'davfs2',
                'wheel',
              ],
  }
  
  file { '/etc/profile.d/path.sh':
    content => 'export PATH=/sbin:/usr/sbin:/usr/local/sbin:$PATH',
  }
  
}
