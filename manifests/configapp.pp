class twlight::configapp inherits twlight {

  # Start gunicorn
  exec { 'gunicorn_start':
    command     => "/etc/init.d/gunicorn start"
  }

  # Configure virtual environment
  exec { 'virtualenv_init':
    command     => "./virtualenv_init.sh",
    path        => "/home/$twlight_unixname",
    user        => $twlight_unixname
  }

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
    ensure  => file,
    owner   => $twlight_unixname,
    group   => $twlight_unixname,
    mode    => '0644'
  }

  # Gunicorn server log
  file { '/var/www/html/TWLight/TWLight/logs/gunicorn.log':
    ensure  => file,
    owner   => $twlight_unixname,
    group   => $twlight_unixname,
    mode    => '0644'
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

  # Virtualenv bootstrap script
  file {"/home/$twlight_unixname/virtualenv_init.sh":
    mode => "0755",
    owner => $twlight_unixname,
    group => $twlight_unixname,
    content => template('twlight/virtualenv_init.sh.erb'),
    notify  => Exec['virtualenv_init']
  }

  # gunicorn config
  file {'/etc/init.d/gunicorn':
    mode => "0755",
    owner => 'root',
    group => 'root',
    content => template('twlight/gunicorn.erb'),
  }

  # gunicorn start on boot
  file { '/etc/rc3.d/S05gunicorn':
    ensure  => 'link',
    target  => '/etc/init.d/gunicorn',
    force   => true,
    notify  => Exec['gunicorn_start']
  }

}
