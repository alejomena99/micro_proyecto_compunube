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
    command     => "/usr/bin/sudo consul agent -ui -dev -bind=${environment.PRIVATE_IP} -client=0.0.0.0 -data-dir=.",
    refreshonly => true, 
    async       => true,
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
    mode    => '0644',
    source  => 'puppet:///modules/baseconfig/index.js',
  }

  exec { 'npm_install_consul':
    command     => '/usr/bin/npm install consul',
    cwd         => '/home/vagrant/consulService/app',
    refreshonly => true, 
    require     => [Package['nodejs'], Package['npm']],
  }

  exec { 'npm_install_express':
    command     => '/usr/bin/npm install express',
    cwd         => '/home/vagrant/consulService/app',
    refreshonly => true, 
    require     => [Package['nodejs'], Package['npm']],
  }

}
