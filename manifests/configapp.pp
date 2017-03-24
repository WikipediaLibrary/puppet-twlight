class twlight::configapp inherits twlight {

  file { '/etc/nginx/sites-available/twlight':
    ensure  => file,
    content => template('twlight/nginx.conf.twlight.erb'),
    owner   => '33',
    group   => '33',
    mode    => '0644',
  }

  file { '/etc/nginx/sites-enabled/twlight':
    ensure  => 'link',
    target  => '/etc/nginx/sites-available/twlight',
    force   => true,
  }

  file { '/var/www/html/TWLight/TWLight/settings/production_vars.py':
    ensure  => file,
    content => template('twlight/production_vars.py.erb'),
    owner   => '33',
    group   => '33',
    mode    => '0444',
  }
}
