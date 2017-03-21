class twlight::install inherits twlight {

  # Install our packages
  if $twlight::package_manage {
    package { $package_name:
      ensure => $package_ensure,
    }
  }

  # Install and config mariadb server using another module
  class {'::mysql::server':
    package_name            => 'mariadb-server',
    package_ensure          => 'present',
    service_name            => 'mysql',
    root_password           => $mysqlroot,
    remove_default_accounts => true,
  }

  # Install and config mariadb client using another module
  class {'::mysql::client':
    package_name   => 'mariadb-client',
    package_ensure => 'present',
  }
}

