class baseconfig {
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

  exec { 'run_consul_agent':
    command     => "/usr/bin/sudo consul agent -ui -dev -bind=${private_ip} -client=0.0.0.0 -data-dir=. > /var/log/consul.log 2>&1 &",
    onlyif      => "/usr/bin/pgrep consul > /dev/null || true",
    require     => Package['consul'],
  }

  package { 'python3-pip':
    ensure => 'installed',
  }

  exec { 'pip3 install jupyter':
    command     => '/usr/bin/pip3 install jupyter',
    path        => '/usr/local/bin:/usr/bin',
    refreshonly => true,
    subscribe   => Package['python3-pip'],
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
    source  => 'puppet:///modules/baseconfig/index.js',
  }

  exec { 'chmod_x_index_js':
    command     => 'chmod +x /home/vagrant/consulService/app/index.js',
    path        => ['/bin', '/usr/bin'],
    subscribe   => File['/home/vagrant/consulService/app/index.js'],
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
    environment => [ "private_ip=${private_ip}", "microservice_name=${microservice_name}" ],
    require     => [Exec['npm_install_consul'], Exec['npm_install_express']],
  }

  exec { 'start_node_app3004':
    command     => '/usr/bin/node index.js 3004 &',
    user        => 'vagrant',
    cwd         => '/home/vagrant/consulService/app',
    environment => [ "private_ip=${private_ip}", "microservice_name=${microservice_name}" ],
    require     => [Exec['npm_install_consul'], Exec['npm_install_express']],
  }

}
