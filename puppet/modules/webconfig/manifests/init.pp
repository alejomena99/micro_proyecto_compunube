class webconfig {
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
  }

  package { 'nodejs':
    ensure => 'installed',
  }

  package { 'npm':
    ensure => 'installed',
  }

  package { 'net-tools':
    ensure => 'installed',
  }

  package { 'consul':
    ensure => 'installed',
  }

  file { '/home/vagrant/consulService':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/home/vagrant/consulService/app':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/home/vagrant/consulService/app/index.js':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/webconfig/index.js',
  }

  exec { 'npm_install_consul':
    command     => '/usr/bin/npm install consul',
    cwd         => '/home/vagrant/consulService/app',
    require     => [Package['nodejs'], Package['npm']],
  }

  exec { 'npm_install_express':
    command     => '/usr/bin/npm install express',
    cwd         => '/home/vagrant/consulService/app',
    require     => [Package['nodejs'], Package['npm']],
  }

  exec { 'start_node_app3003':
    command     => '/usr/bin/node index.js 3003 &',
    user        => 'vagrant',
    cwd         => '/home/vagrant/consulService/app',
    environment => [ "private_ip=${private_ip}", "microservice_name=${microservice_name}", "consul_ip=${consul_ip}", "service_id=${service_id}"],
    require     => [Exec['npm_install_consul'], Exec['npm_install_express']],
  }

  exec { 'start_node_app3004':
    command     => '/usr/bin/node index.js 3004 &',
    user        => 'vagrant',
    cwd         => '/home/vagrant/consulService/app',
    environment => [ "private_ip=${private_ip}", "microservice_name=${microservice_name}", "consul_ip=${consul_ip}", "service_id=${service_id}"],
    require     => [Exec['npm_install_consul'], Exec['npm_install_express']],
  }

}
