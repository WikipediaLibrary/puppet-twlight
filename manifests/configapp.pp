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

  # TWLight app log
  file { '/var/www/html/TWLight/TWLight/logs/twlight.log':
    ensure  => file
  }

  # Gunicorn server log
  file { '/var/www/html/TWLight/TWLight/logs/gunicorn.log':
    ensure  => file
  }

  # Set perms for TWLight tree
  file { '/var/www/html/TWLight':
    ensure  => directory,
    recurse => true,
    owner   => $twlight_unixname,
    group   => $twlight_unixname,
  }

  file { '/var/www/html/TWLight/TWLight/settings/production_vars.py':
    ensure  => file,
    content => template('twlight/production_vars.py.erb'),
    owner   => $twlight_unixname,
    group   => $twlight_unixname,
    mode    => '0400',
  }
}
