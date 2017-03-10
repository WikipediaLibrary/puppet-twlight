class twlight {
  
  # execute 'apt-get update'
  exec { 'apt-update':                    # exec resource named 'apt-update'
    command => '/usr/bin/apt-get update'  # command this resource will run
  }
  
  # Some puppet modules require encrypted repos.
  package { 'apt-transport-https':
    require => Exec['apt-update'],        # require 'apt-update' before installing
    ensure => installed,
  }
  
  # install TWLight system dependencies
  
  package { 'build-essential':
    require => Exec['apt-update'],        # require 'apt-update' before installing
    ensure => installed,
  }
  
  package { 'git':
    require => Exec['apt-update'],        # require 'apt-update' before installing
    ensure => installed,
  }
  
  package { 'libmysqlclient-dev':
    require => Exec['apt-update'],        # require 'apt-update' before installing
    ensure => installed,
  }
  
  #package { 'mariadb-server':
  #  require => Exec['apt-update'],        # require 'apt-update' before installing
  #  ensure => installed,
  #}
  
  #package { 'nginx':
  #  require => Exec['apt-update'],        # require 'apt-update' before installing
  #  ensure => installed,
  #}
  
  package { 'python-dev':
    require => Exec['apt-update'],        # require 'apt-update' before installing
    ensure => installed,
  }
  
  package { 'python-pip':
    require => Exec['apt-update'],        # require 'apt-update' before installing
    ensure => installed,
  }
  
  # Install mariadb server
  class {'::mysql::server':
    package_name => 'mariadb-server',
    root_password           => $mysqlroot,
    remove_default_accounts => true,
  }
  
  # Install mariadb client
  class {'::mysql::client':
    package_name => 'mariadb-client',
  }
  
  # Check mtime on tzdata
  file { '/usr/share/zoneinfo':
    audit => mtime,
    recurse => true,
    notify => Exec['mysql_tzinfo']
  }
  
  # Load timezone tables into mysql on refresh
  exec { 'mysql_tzinfo':
    refreshonly => true,
    command => "/usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user root --password=$mysqlroot mysql",
  }
  
  # Create twlight database
  # CREATE DATABASE twlight CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_general_ci';
  # GRANT ALL PRIVILEGES on twlight.* to twlight@'localhost' IDENTIFIED BY '<password>';
  mysql::db { 'twlight':
    user     => 'twlight',
    password => $mysqltwlight,
    host     => 'localhost',
    charset => 'utf8mb4',
    collate => 'utf8mb4_general_ci',
    grant    => ['ALL'],
  }
  
  # Install nginx
  class { 'nginx': }
  
  # www dir
  file { '/var/www':
    ensure => 'directory',
    owner  => '33',
    group  => '33',
    mode   => '755',
  }
  
  # www/html dir
  file { '/var/www/html':
    ensure => 'directory',
    owner  => '33',
    group  => '33',
    mode   => '755',
  }
  
  vcsrepo { '/var/www/html/TWLight':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/WikipediaLibrary/TWLight.git',
  }
  
  file { '/var/www/html/TWLight/TWLight/settings/production_vars.py':
    ensure  => file,
    content => template('twlight/production_vars.py.erb'),
    owner  => '33',
    group  => '33',
    mode   => '444',
  }
  
  #nginx::resource::server { 'debian-8':
  #  www_root => '/var/www/www.puppetlabs.com',
  #}
}
