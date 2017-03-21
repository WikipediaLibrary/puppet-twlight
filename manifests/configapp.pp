class twlight::configapp inherits twlight {

  file { '/var/www/html/TWLight/TWLight/settings/production_vars.py':
    ensure  => file,
    content => template('twlight/production_vars.py.erb'),
    owner   => '33',
    group   => '33',
    mode    => '0444',
  }
}