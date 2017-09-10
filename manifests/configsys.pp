class twlight::configsys inherits twlight {

  # Create user to execute virtual environment and gunicorn
  user { $twlight_unixname:
    ensure     => present,
    comment    => 'twlight user',
    shell      => '/bin/bash',
    managehome => true,
  }

  # Check mtime on tzdata
  file { '/usr/share/zoneinfo':
    audit   => mtime,
    recurse => true,
    notify  => Exec['mysql_tzinfo']
  }

  # Load timezone tables into mysql on refresh
  exec { 'mysql_tzinfo':
    refreshonly => true,
    command     => "/usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user root --password=${twlight_mysqlroot_pw} mysql",
  }

  # config mariadb server using another module
  class {'::mysql::server':
    package_manage          => false,
    service_name            => 'mysql',
    root_password           => $twlight_mysqlroot_pw,
    remove_default_accounts => true
  }

  class {'::mysql::client':
    package_manage          => false,
  }

  # Create twlight database
  # CREATE DATABASE twlight;
  # GRANT ALL PRIVILEGES on twlight.* to twlight@'localhost' IDENTIFIED BY '<password>';
  mysql::db { 'twlight':
    user     => 'twlight',
    password => $twlight_mysqltwlight_pw,
    host     => 'localhost',
    grant    => ['ALL'],
  }

  if $twlight_environment != 'production' {
    # Create twlight test database
    # CREATE DATABASE test_twlight;
    # GRANT ALL PRIVILEGES on test_twlight.* to test_twlight@'localhost' IDENTIFIED BY '<password>';
    mysql::db { 'test_twlight':
      user     => 'twlight',
      password => $twlight_mysqltwlight_pw,
      host     => 'localhost',
      grant    => ['ALL'],
    }
  }

  # www dir
  file { '/var/www':
    ensure => 'directory',
    owner  => '33',
    group  => '33',
    mode   => '0755',
  }

  # www/html dir
  file { '/var/www/html':
    ensure => 'directory',
    owner  => '33',
    group  => '33',
    mode   => '0755',
  }

  # nginx config
  file {'/etc/nginx/nginx.conf':
    mode   => '0644',
    owner  => '33',
    group  => '33',
    source => 'puppet:///modules/twlight/nginx.conf.webserver',
    notify => Exec['nginx_reload']
  }

}
