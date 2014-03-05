class cassandra {

  package
  { [ "oracle-java7-jdk", "libcommons-daemon-java", "jsvc" ]:
    ensure => "installed",
    require => [Exec['apt-get update'], File["/etc/apt/apt.conf.d/99auth"]],
  }

  exec
  { 'copy-cassandra':
    command => 'cp /vagrant/apache-cassandra-1.2.15-bin.tar.gz /home/vagrant',
    onlyif => 'test ! -e /home/vagrant/apache-cassandra-1.2.15-bin.tar.gz',
  }
  
  exec
  { 'install':
    require => [Exec['copy-cassandra'], Package['oracle-java7-jdk']],
    cwd => '/home/vagrant',
    command => 'tar xvfz apache-cassandra-1.2.15-bin.tar.gz',
    onlyif => 'test ! -d apache-cassandra-1.2.15',
  }

  exec
  { 'create-link':
    require => Exec['install'],
    command => 'ln -s /home/vagrant/apache-cassandra-1.2.15 /home/vagrant/apache-cassandra',
    onlyif => 'test ! -h /home/vagrant/apache-cassandra',
  }

  exec
  { 'copy-init':
    command => 'cp /vagrant/cassandra/cassandra.init /etc/init.d/cassandra',
    onlyif => 'test ! -e /etc/init.d/cassandra',
  }

  exec
  { 'install-init':
    require => Exec['copy-init'],
    command => 'chmod +x /etc/init.d/cassandra; update-rc.d cassandra defaults 99',
    onlyif => 'test ! -x /etc/init.d/cassandra',
  }

  service
  { 'cassandra':
    name => 'cassandra',
    ensure => running,
    start => '/etc/init.d/cassandra start',
    stop => '/etc/init.d/cassandra stop',
    status => '/etc/init.d/cassandra status',
    restart => '/etc/init.d/cassandra restart',
    enable => true,
  }

  cassandra_config
  { puppet:
    listenaddress => $ipaddress_eth1,
  }

  file
  { 'casandra-env.sh':
    require => Exec['create-link'],
    path => '/home/vagrant/apache-cassandra/conf/cassandra-env.sh',
    owner => 'vagrant',
    group => 'vagrant',
    mode => 444,
    content => template('cassandra/cassandra-env.sh.erb')
  }
}

define cassandra_config($listenaddress) {
  file
  { 'cassandra.yaml':
    require => Exec['create-link'],
    path => '/home/vagrant/apache-cassandra/conf/cassandra.yaml',
    owner => 'vagrant',
    group => 'vagrant',
    mode => 444,
    content => template('cassandra/cassandra.yaml.erb'),
    notify => Service['cassandra'],
  }
}
