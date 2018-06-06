class twlight::install inherits twlight {

  # execute 'apt-get update'
  exec { 'apt-update':
    command => '/usr/bin/apt-get update',
    notify  =>Exec['virtualenv_install']
  }

  # Install our packages
  if $twlight::package_manage {
    package { $package_name:
      ensure  => $package_ensure,
      require => Exec['apt-update'],
      before  => Exec['virtualenv_install'],
    }
  }

  # Pip install virtualenv
  exec { 'virtualenv_install':
    command     => '/usr/bin/pip install virtualenv'
  }

}
