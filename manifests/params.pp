class twlight::params {
  $git_repository =  lookup('twlight::params::git_repository', {value_type => String, default_value => 'https://github.com/WikipediaLibrary/TWLight.git'})
  $git_revision =  lookup('twlight::params::git_revision', {value_type => String, default_value => 'master'})
  $mysqlroot_pw = lookup('twlight::params::mysqlroot_pw', {value_type => String})
  $mysqltwlight_pw = lookup('twlight::params::mysqltwlight_pw', {value_type => String})
  $restore_file = lookup('twlight::params::restore_file', {value_type => String, default_value => '/dev/false'})
  $backup_dir = lookup('twlight::params::backup_dir', {value_type => String})
  $servername = lookup('twlight::params::servername', {value_type => String})
  $secretkey = lookup('twlight::params::secretkey', {value_type => String})
  $allowedhosts = lookup('twlight::params::allowedhosts', {value_type => String})
  $oauth_key = lookup('twlight::params::oauth_key', {value_type => String})
  $oauth_secret = lookup('twlight::params::oauth_secret', {value_type => String})
  $error_mailto = lookup('twlight::params::error_mailto', {value_type => String, default_value => 'wikipedialibrary@wikimedia.org'})
  $root_dir = '/var/www/html/TWLight'
  $mysqldump_dir = '/var/www/html/TWLight'
  $serverport = lookup('twlight::params::serverport', {value_type => String, default_value => '443'})
  $externalport = lookup('twlight::params::externalport', {value_type => String, default_value => '443'})
  $environment = lookup('twlight::params::environment', {value_type => String, default_value => 'production'})
  $unixname = lookup('twlight::params::unixname', {value_type => String, default_value => 'www'})
  $baseurl = "http://${servername}/"
  $oauth_provider_url = "https://meta.wikimedia.org/w/index.php"
  $mysql_override_options = {
    'client' => {
      'socket' => '/tmp/mysql.sock',
      'default-character-set' => 'utf8mb4',
    },
    'mysqld' => {
      'socket' => '/tmp/mysql.sock',
      'innodb_file_per_table' => '1',
      'innodb_large_prefix' => '1',
      'innodb_file_format' => 'Barracuda',
      'innodb_default_row_format' => 'DYNAMIC',
      'innodb_compression_default' => '1',
      'innodb_page_size' => '64k',
      'collation-server' => 'utf8mb4_unicode_ci',
      'init-connect' => 'SET NAMES utf8mb4',
      'character-set-server' => 'utf8mb4',
    },
    'mysqld_safe' => {
      'socket' => '/tmp/mysql.sock',
      'default-character-set' => 'utf8mb4'
    },
  }

  $package_manage = true
  $package_ensure = 'present'

  case $operatingsystemrelease {
    /^8.*/: {
      $default_package_name = [
        'build-essential',
        'gettext',
        'git',
        'libmariadb-client-lgpl-dev',
        'libssl-dev',
        'mariadb-client',
        'mariadb-server',
        'nginx',
        'nodejs',
        'pandoc',
        'python-dev',
        'python-pip',
      ]
    }
    /^9.*/: {
      $default_package_name = [
        'build-essential',
        'gettext',
        'git',
        'libmariadb-dev',
        'libssl-dev',
        'mariadb-client',
        'mariadb-server',
        'nginx',
        'nodejs',
        'pandoc',
        'python-dev',
        'python-pip',
      ]
    }
}

  case $::osfamily {
    'Debian': {
      $package_name = $default_package_name
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
