class twlight::configsys inherits twlight {

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
}
