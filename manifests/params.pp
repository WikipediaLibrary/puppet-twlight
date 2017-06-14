class twlight::params {

  $package_manage = true
  $package_ensure = 'present'

  $default_package_name = [
  'apt-transport-https',
  'build-essential',
  'gettext',
  'git',
  'libmysqlclient-dev',
  'mariadb-client',
  'mariadb-server',
  'nginx',
  'pandoc',
  'python-dev',
  'python-pip',
  ]

  case $::osfamily {
    'Debian': {
      $package_name = $default_package_name
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
