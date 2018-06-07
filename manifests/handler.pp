class twlight::handler inherits twlight {

  # Import Backup if available
  exec { 'mysql_import':
    command   => "/bin/bash ${root_dir}/bin/twlight_restore.sh ${restore_file}",
    logoutput => true,
    onlyif    => "/usr/bin/stat ${restore_file}",
  }

  # Reload nginx
  exec { 'nginx_reload':
    command     => '/usr/sbin/nginx -t && /bin/systemctl reload nginx',
    refreshonly => true,
  }

  # Configure virtual environment
  exec { 'virtualenv_update':
    command => "/bin/bash ${root_dir}/bin/update_code.sh",
  }

}
