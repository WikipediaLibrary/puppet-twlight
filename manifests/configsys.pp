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
    command     => "/usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user root --password=${mysqlroot} mysql",
  }

  # Reload nginx
  exec { 'nginx_reload':
    command     => "/usr/sbin/nginx -t && /bin/systemctl reload nginx"
  }

  # config mariadb server using another module
  class {'::mysql::server':
    package_manage          => false,
    service_name            => 'mysql',
    root_password           => $mysqlroot,
    remove_default_accounts => true
  }

  class {'::mysql::client':
    package_manage          => false,
  }

  # Create twlight database
  # CREATE DATABASE twlight CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_general_ci';
  # GRANT ALL PRIVILEGES on twlight.* to twlight@'localhost' IDENTIFIED BY '<password>';
  mysql::db { 'twlight':
    user     => 'twlight',
    password => $mysqltwlight,
    host     => 'localhost',
    charset  => 'utf8mb4',
    collate  => 'utf8mb4_general_ci',
    grant    => ['ALL'],
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
    mode => "0644",
    owner => '33',
    group => '33',
    source => 'puppet:///modules/twlight/nginx.conf.webserver',
    notify  => Exec['nginx_reload']
  }

}
