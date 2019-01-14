class twlight::configapp inherits twlight {

  # reload systemd
  exec { 'daemon_reload':
    command   => '/bin/systemctl daemon-reload',
    subscribe => [ File["${root_dir}/TWLight/settings/${environment}_vars.py"], File['/etc/rc3.d/S05gunicorn'] ],
    notify    => Exec['nginx_reload'],
  }

  # Install cssjanus in twlight users homedir
  exec { 'npm_install_cssjanus':
    command   => '/usr/bin/npm install cssjanus',
    cwd       => "/home/${unixname}",
    user      => "${unixname}",
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
  file { "${root_dir}/TWLight/logs/twlight.log":
    ensure => file,
    owner  => $unixname,
    group  => $unixname,
    mode   => '0644',
  }

  # Gunicorn server log
  file { "${root_dir}/TWLight/logs/gunicorn.log":
    ensure => file,
    owner  => $unixname,
    group  => $unixname,
    mode   => '0644',
  }

  # TWLight update log
  file { "${root_dir}/TWLight/logs/update.log":
    ensure => file,
    owner  => $unixname,
    group  => $unixname,
    mode   => '0644',
  }

  # TWLight test log
  file { "${root_dir}/TWLight/logs/test.log":
    ensure => file,
    owner  => $unixname,
    group  => $unixname,
    mode   => '0644',
  }

  # Set perms for TWLight tree
  file { "${root_dir}":
    ensure  => directory,
    recurse => true,
    owner   => $unixname,
    group   => $unixname,
  }

  # We always write out local vars so that we can run tests.
  if $environment != 'local' {
    file { "${root_dir}/TWLight/settings/local_vars.py":
      ensure  => file,
      content => template('twlight/local_vars.py.erb'),
      owner   => $unixname,
      group   => $unixname,
      mode    => '0400',
    }
  }

  file { "${root_dir}/TWLight/settings/${environment}_vars.py":
    ensure  => file,
    content => template("twlight/${environment}_vars.py.erb"),
    owner   => $unixname,
    group   => $unixname,
    mode    => '0400',
  }

  # Global environment variables.
  file { '/etc/environment':
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('twlight/environment.erb'),
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
  if $environment != 'local' {

    # weekly cron task
    file { '/etc/cron.weekly/twlight':
      ensure => 'link',
      target => "${root_dir}/bin/twlight_weekly.sh",
      force  => true,
    }

    # cron deploy task
    file { '/etc/cron.d/twlight':
      mode   => '0644',
      owner  => '0',
      group  => '0',
      source => 'puppet:///modules/twlight/deploy.cron',
    }

    # cron backup task
    file {'/etc/cron.daily/twlight':
      mode   => '0644',
      owner  => '33',
      group  => '33',
      source => 'puppet:///modules/twlight/backup.cron',
    }

  }

}
