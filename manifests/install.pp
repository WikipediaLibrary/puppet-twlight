class twlight::install inherits twlight {

  # execute 'apt-get update'
  exec { 'apt-update':
    command => '/usr/bin/apt-get update',
#    notify  =>Exec['virtualenv_install']
  }

  # Install our packages
  if $twlight::package_manage {
    package { $package_name:
      ensure  => $package_ensure,
#      require => Exec['apt-update'],
#      before  => Exec['virtualenv_install'],
    }
  }

  # Pip install virtualenv
  exec { 'virtualenv_install':
    command     => '/usr/bin/pip install virtualenv',
    before      => Tidy['mysql_ibdata'],
  }

# Delete the database so we can change the block size
#  tidy { 'mysql_ibdata':
#    path    => '/var/lib/mysql',
#    recurse => true,
#    matches => ['ibdata1','ib_logfile*'],
##    require => Exec['virtualenv_install']
##    require => Package['mariadb-server'],
##    notify  => Exec['mysql_tidy_restart'],
##    before  => File['mysql-config-file'],
#    before  => Class['Mysql::Server::Config'],
##    before  => Mysql::Server::Config/File[mysql-config-file],
#  }
#
}
