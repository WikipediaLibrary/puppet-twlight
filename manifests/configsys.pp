class twlight::configsys inherits twlight {

  # Create user to execute virtual environment and gunicorn
  user { $twlight_unixname:
    ensure     => present,
    comment    => 'twlight user',
    shell      => '/bin/bash',
    managehome => true,
  }

  # needed since libmariadb-client-lgpl-dev is providing client development files.
  file { '/usr/bin/mysql_config':
    ensure => 'link',
    target => '/usr/bin/mariadb_config',
  }

  # Delete the database so we can change the block size
  tidy { 'mysql_ibdata':
    path    => '/var/lib/mysql',
    recurse => true,
    matches => ['ibdata1','ib_logfile*'],
    require => Package['mariadb-server'],
    notify  => Exec['mysql_tidy_restart'],
    before => Class['::mysql::server'],
  }

  # Restart MySQL after tidy
  exec { 'mysql_tidy_restart':
    command     => '/bin/systemctl restart mysql',
    unless    => '/usr/bin/stat /var/lib/mysql/ibdata1 /var/lib/mysql/ib_logfile*',
  }

  # config mariadb server using another module
  class {'::mysql::server':
    package_manage          => false,
    service_name            => 'mysql',
    root_password           => $twlight_mysqlroot_pw,
    remove_default_accounts => true,
    override_options        => $twlight_mysql_override_options,
    require                 => Tidy['mysql_ibdata'],
    restart                 => false,
  }

  # Load timezone tables into mysql on refresh
  exec { 'mysql_tzinfo':
    command     => "/usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo | /usr/bin/mysql --user root --password=${twlight_mysqlroot_pw} mysql",
#    require => Class['::mysql::server'],
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
    password => $twlight_mysqltwlight_pw,
    host     => 'localhost',
    grant    => ['ALL'],
    require => Package['mariadb-client', 'mariadb-server'],
  }

  # Create twlight test database
  # CREATE DATABASE test_twlight;
  # GRANT ALL PRIVILEGES on test_twlight.* to test_twlight@'localhost' IDENTIFIED BY '<password>';
  mysql::db { 'test_twlight':
    user     => 'twlight',
    password => $twlight_mysqltwlight_pw,
    host     => 'localhost',
    grant    => ['ALL'],
    require => Package['mariadb-client', 'mariadb-server'],
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
