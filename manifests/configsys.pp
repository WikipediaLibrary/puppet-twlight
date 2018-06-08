class twlight::configsys inherits twlight {

  # Create user to execute virtual environment and gunicorn
  user { $unixname:
    ensure     => present,
    comment    => 'twlight user',
    shell      => '/bin/bash',
    managehome => true,
  }

  # Delete the database so we can change the block size
  $ib1_files = ['ibdata1', 'ib_logfile0', 'ib_logfile1']

  $ib1_files.each |String $ib1_file| {
    File {"/var/lib/mysql/${ib1_file}":
      ensure  => 'absent',
      notify => Exec['mysql_restart']
    }
  }

  # Restart MySQL service
  exec { 'mysql_restart':
    command     => '/bin/systemctl restart mysql',
  }

  # config mariadb server using another module
  class {'::mysql::server':
    package_manage          => false,
    service_name            => 'mysql',
    root_password           => $mysqlroot_pw,
    remove_default_accounts => true,
    override_options        => $mysql_override_options,
    require => Package['mariadb-server'],
  }

  # needed since libmariadb-client-lgpl-dev is providing client development files.
  file { '/usr/bin/mysql_config':
    ensure  => 'link',
    target  => '/usr/bin/mariadb_config',
  }

  # Load timezone tables into mysql on refresh
  exec { 'mysql_tzinfo':
    command     => "/usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo | /usr/bin/mysql --user root --password=${mysqlroot_pw} mysql",
  }


  class {'::mysql::client':
    package_manage          => false,
    require => Package['mariadb-client'],
  }

  # Create twlight database
  # CREATE DATABASE twlight;
  # GRANT ALL PRIVILEGES on twlight.* to twlight@'localhost' IDENTIFIED BY '<password>';
  mysql::db { 'twlight':
    user     => 'twlight',
    password => $mysqltwlight_pw,
    host     => 'localhost',
    grant    => ['ALL'],
    #require => Package['mariadb-client', 'mariadb-server'],
  }

  # Create twlight test database
  # CREATE DATABASE test_twlight;
  # GRANT ALL PRIVILEGES on test_twlight.* to test_twlight@'localhost' IDENTIFIED BY '<password>';
  mysql::db { 'test_twlight':
    user     => 'twlight',
    password => $mysqltwlight_pw,
    host     => 'localhost',
    grant    => ['ALL'],
    #require => Package['mariadb-client', 'mariadb-server'],
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

  # remove default nginx site
  file {'/etc/nginx/sites-enabled/default':
    ensure => 'absent',
    notify => Exec['nginx_reload']
  }
}
