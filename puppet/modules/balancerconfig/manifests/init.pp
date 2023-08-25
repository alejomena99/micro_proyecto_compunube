class balancerconfig {
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
  }

  package { 'net-tools':
    ensure => 'installed',
  }

  package { 'haproxy':
    ensure => 'installed',
  }

  exec { 'enable_haproxy':
    command => '/usr/bin/systemctl enable haproxy',
  }

  file { '/etc/haproxy/haproxy.cfg':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/balancerconfig/haproxy.cfg',
  }

  exec { 'restart_haproxy':
    command => '/usr/bin/sudo systemctl restart haproxy',
  }
}
