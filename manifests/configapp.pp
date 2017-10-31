class twlight::configapp inherits twlight {

  # reload systemd
  exec { 'daemon_reload':
    command   => '/bin/systemctl daemon-reload',
    subscribe => [ File["/var/www/html/TWLight/TWLight/settings/${twlight_environment}_vars.py"], File['/etc/rc3.d/S05gunicorn'] ],
    notify    => Exec['nginx_reload'],
  }

  file { '/etc/nginx/sites-available/twlight':
    ensure  => file,
    content => template('twlight/nginx.conf.twlight.erb'),
    owner   => '33',
    group   => '33',
    mode    => '0644',
  }

  file { '/etc/nginx/sites-enabled/twlight':
    ensure => 'link',
    target => '/etc/nginx/sites-available/twlight',
    force  => true,
  }

  # TWLight app log
  file { '/var/www/html/TWLight/TWLight/logs/twlight.log':
    ensure => file,
    owner  => $twlight_unixname,
    group  => $twlight_unixname,
    mode   => '0644',
  }

  # Gunicorn server log
  file { '/var/www/html/TWLight/TWLight/logs/gunicorn.log':
    ensure => file,
    owner  => $twlight_unixname,
    group  => $twlight_unixname,
    mode   => '0644',
  }

  # TWLight update log
  file { '/var/www/html/TWLight/TWLight/logs/update.log':
    ensure => file,
    owner  => $twlight_unixname,
    group  => $twlight_unixname,
    mode   => '0644',
  }

  # TWLight test log
  file { '/var/www/html/TWLight/TWLight/logs/test.log':
    ensure => file,
    owner  => $twlight_unixname,
    group  => $twlight_unixname,
    mode   => '0644',
  }

  # Set perms for TWLight tree
  file { '/var/www/html/TWLight':
    ensure  => directory,
    recurse => true,
    owner   => $twlight_unixname,
    group   => $twlight_unixname,
  }

  # We always write out local vars so that we can run tests.
  if $twlight_environment != 'local' {
    file { '/var/www/html/TWLight/TWLight/settings/local_vars.py':
      ensure  => file,
      content => template('twlight/local_vars.py.erb'),
      owner   => $twlight_unixname,
      group   => $twlight_unixname,
      mode    => '0400',
    }
  }

  file { "/var/www/html/TWLight/TWLight/settings/${twlight_environment}_vars.py":
    ensure  => file,
    content => template("twlight/${twlight_environment}_vars.py.erb"),
    owner   => $twlight_unixname,
    group   => $twlight_unixname,
    mode    => '0400',
  }

  # Virtualenv activate script
  file { '/var/www/html/TWLight/bin/virtualenv_activate.sh':
    mode    => '0755',
    owner   => $twlight_unixname,
    group   => $twlight_unixname,
    content => template('twlight/virtualenv_activate.sh.erb'),
  }

  # Virtualenv clear static script
  file { '/var/www/html/TWLight/bin/virtualenv_clearstatic.sh':
    mode    => '0755',
    owner   => $twlight_unixname,
    group   => $twlight_unixname,
    content => template('twlight/virtualenv_clearstatic.sh.erb'),
  }

  # Virtualenv migrate script
  file { '/var/www/html/TWLight/bin/virtualenv_migrate.sh':
    mode    => '0755',
    owner   => $twlight_unixname,
    group   => $twlight_unixname,
    content => template('twlight/virtualenv_migrate.sh.erb'),
  }

  # Virtualenv pip update script
  file { '/var/www/html/TWLight/bin/virtualenv_pip_update.sh':
    mode    => '0755',
    owner   => $twlight_unixname,
    group   => $twlight_unixname,
    content => template('twlight/virtualenv_pip_update.sh.erb'),
  }

  # Virtualenv test script
  file { '/var/www/html/TWLight/bin/virtualenv_test.sh':
    mode    => '0755',
    owner   => $twlight_unixname,
    group   => $twlight_unixname,
    content => template('twlight/virtualenv_test.sh.erb'),
  }

  # Virtualenv translate script
  file { '/var/www/html/TWLight/bin/virtualenv_translate.sh':
    mode    => '0755',
    owner   => $twlight_unixname,
    group   => $twlight_unixname,
    content => template('twlight/virtualenv_translate.sh.erb'),
  }

  # Virtualenv update script
  file { '/var/www/html/TWLight/bin/virtualenv_update.sh':
    mode    => '0755',
    owner   => $twlight_unixname,
    group   => $twlight_unixname,
    content => template('twlight/virtualenv_update.sh.erb'),
  }

  # mysql dump script
  file { '/var/www/html/TWLight/bin/twlight_mysqldump.sh':
    owner   => $twlight_unixname,
    group   => $twlight_unixname,
    mode    => '0755',
    content => template('twlight/twlight_mysqldump.sh.erb'),
  }

  # TWLight git pull wrapper script
  file { '/var/www/html/TWLight/bin/twlight_update_code.sh':
    ensure  => file,
    content => template('twlight/twlight_update_code.sh.erb'),
    owner   => $twlight_unixname,
    group   => $twlight_unixname,
    mode    => '0755',
  }

  # gunicorn start script
  file { '/var/www/html/TWLight/bin/gunicorn_start.sh':
    ensure  => file,
    content => template('twlight/gunicorn_start.sh.erb'),
    owner   => $twlight_unixname,
    group   => $twlight_unixname,
    mode    => '0755',
  }

  # gunicorn config
  file {'/etc/init.d/gunicorn':
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('twlight/gunicorn.erb'),
  }

  # gunicorn start on boot
  file { '/etc/rc3.d/S05gunicorn':
    ensure => 'link',
    target => '/etc/init.d/gunicorn',
    force  => true,
  }

  # These cron tasks don't make too much sense in local environments
  if $twlight_environment != 'local' {

    # mysql dump cron task
    file { '/etc/cron.daily/twlight-mysqldump':
      ensure => 'link',
      target => '/var/www/html/TWLight/bin/twlight_mysqldump.sh',
      force  => true,
    }

    # TWLight git pull cron task
    file { '/etc/cron.daily/twlight-update-code':
      ensure => 'link',
      target => '/var/www/html/TWLight/bin/twlight_update_code.sh',
      force  => true,
    }

  }

}
