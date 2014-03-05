class system-update {
  exec
  { 'apt-get update':
    command => 'apt-get update',
  }

  file
  { "/etc/apt/apt.conf.d/99auth":
    owner => root,
    group => root,
    content => "APT::Get::AllowUnauthenticated yes;",
    mode => 644;
  }

  hosts_config
  { puppet:
    listenaddress => $ipaddress_eth1,
    hostname => $fqdn,
  }
}

define hosts_config($listenaddress, $hostname) {
  file
  { "/etc/hosts":
    path => "/etc/hosts",
    owner   => root,
    group   => root,
    mode    => 444,
    content => template("system-update/hosts.erb"),
  }
}
