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
}
