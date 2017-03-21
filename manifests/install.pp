class twlight::install inherits twlight {

  # execute 'apt-get update'
  exec { 'apt-update':                    # exec resource named 'apt-update'
    command => '/usr/bin/apt-get update'  # command this resource will run
  }

  # Install our packages
  if $twlight::package_manage {
    package { $package_name:
      ensure  => $package_ensure,
      require => Exec['apt-update']
    }
  }

  # Install and config mariadb server using another module
  class {'::mysql::server':
    package_name            => 'mariadb-server',
    package_ensure          => 'present',
    service_name            => 'mysql',
    root_password           => $mysqlroot,
    remove_default_accounts => true,
    require                 => Exec['apt-update']
  }

  # Install and config mariadb client using another module
  class {'::mysql::client':
    package_name   => 'mariadb-client',
    package_ensure => 'present',
    require        => Exec['apt-update']
  }
}
