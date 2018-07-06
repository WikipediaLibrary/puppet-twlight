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

  # Virtualenv activate script
  file { "${root_dir}/bin/virtualenv_activate.sh":
    mode    => '0755',
    owner   => $unixname,
    group   => $unixname,
    content => template('twlight/virtualenv_activate.sh.erb'),
  }

  # Virtualenv clear static script
  file { "${root_dir}/bin/virtualenv_clearstatic.sh":
    mode    => '0755',
    owner   => $unixname,
    group   => $unixname,
    content => template('twlight/virtualenv_clearstatic.sh.erb'),
  }

  # Virtualenv migrate script
  file { "${root_dir}/bin/virtualenv_migrate.sh":
    mode    => '0755',
    owner   => $unixname,
    group   => $unixname,
    content => template('twlight/virtualenv_migrate.sh.erb'),
  }

  # Virtualenv pip update script
  file { "${root_dir}/bin/virtualenv_pip_update.sh":
    mode    => '0755',
    owner   => $unixname,
    group   => $unixname,
    content => template('twlight/virtualenv_pip_update.sh.erb'),
  }

  # Virtualenv test script
  file { "${root_dir}/bin/virtualenv_test.sh":
    mode    => '0755',
    owner   => $unixname,
    group   => $unixname,
    content => template('twlight/virtualenv_test.sh.erb'),
  }

  # Virtualenv translate script
  file { "${root_dir}/bin/virtualenv_translate.sh":
    mode    => '0755',
    owner   => $unixname,
    group   => $unixname,
    content => template('twlight/virtualenv_translate.sh.erb'),
  }

  # Virtualenv update script
  file { "${root_dir}/bin/virtualenv_update.sh":
    mode    => '0755',
    owner   => $unixname,
    group   => $unixname,
    content => template('twlight/virtualenv_update.sh.erb'),
  }

  # Virtualenv coordinator reminder script
  file { "${root_dir}/bin/virtualenv_send_coordinator_reminders.sh":
    mode    => '0755',
    owner   => $unixname,
    group   => $unixname,
    content => template('twlight/virtualenv_send_coordinator_reminders.sh.erb'),
  }

  # Daily task wrapper script
  file { "${root_dir}/bin/twlight_daily.sh":
    owner   => $unixname,
    group   => $unixname,
    mode    => '0755',
    content => template('twlight/twlight_daily.sh.erb'),
  }

  # Weekly task wrapper script
  file { "${root_dir}/bin/twlight_weekly.sh":
    owner   => $unixname,
    group   => $unixname,
    mode    => '0755',
    content => template('twlight/twlight_weekly.sh.erb'),
  }

  # Backup script
  file { "${root_dir}/bin/twlight_backup.sh":
    owner   => $unixname,
    group   => $unixname,
    mode    => '0755',
    content => template('twlight/twlight_backup.sh.erb'),
  }

  # Restore script
  file { "${root_dir}/bin/twlight_restore.sh":
    owner   => $unixname,
    group   => $unixname,
    mode    => '0755',
    content => template('twlight/twlight_restore.sh.erb'),
  }

  # Mysql dump script
  file { "${root_dir}/bin/twlight_mysqldump.sh":
    owner   => $unixname,
    group   => $unixname,
    mode    => '0755',
    content => template('twlight/twlight_mysqldump.sh.erb'),
  }

  # Mysql import script
  file { "${root_dir}/bin/twlight_mysqlimport.sh":
    owner   => $unixname,
    group   => $unixname,
    mode    => '0755',
    content => template('twlight/twlight_mysqlimport.sh.erb'),
  }

  # Node.js cssjanus script
  file { "${root_dir}/bin/twlight_cssjanus.js":
    owner   => $unixname,
    group   => $unixname,
    mode    => '0755',
    content => template('twlight/twlight_cssjanus.js.erb'),
  }

  # TWLight git pull wrapper script
  file { "${root_dir}/bin/twlight_update_code.sh":
    ensure  => file,
    content => template('twlight/twlight_update_code.sh.erb'),
    owner   => $unixname,
    group   => $unixname,
    mode    => '0755',
  }

  # gunicorn start script
  file { "${root_dir}/bin/gunicorn_start.sh":
    ensure  => file,
    content => template('twlight/gunicorn_start.sh.erb'),
    owner   => $unixname,
    group   => $unixname,
    mode    => '0755',
  }

  # Failure notification script.
  file { "${root_dir}/bin/twlight_failure.sh":
    ensure  => file,
    content => template('twlight/twlight_failure.sh'),
    owner   => $unixname,
    group   => $unixname,
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
  if $environment != 'local' {

    # weekly cron task
    file { '/etc/cron.weekly/twlight':
      ensure => 'link',
      target => "${root_dir}/bin/twlight_weekly.sh",
      force  => true,
    }

    # daily cron task
    file { '/etc/cron.daily/twlight':
      ensure => 'link',
      target => "${root_dir}/bin/twlight_daily.sh",
      force  => true,
    }

  }

}
