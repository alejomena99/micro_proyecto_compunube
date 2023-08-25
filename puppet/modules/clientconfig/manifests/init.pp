class clientconfig {
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
  }

  package { 'net-tools':
    ensure => 'installed',
  }

  package { 'consul':
    ensure => 'installed',
  }

  exec { 'run_consul_agent':
    command     => "/usr/bin/sudo consul agent -ui -dev -bind=${private_ip} -client=0.0.0.0 -data-dir=. > /var/log/consul.log 2>&1 &",
    onlyif      => "/usr/bin/pgrep consul > /dev/null || true",
    require     => Package['consul'],
  }

}
