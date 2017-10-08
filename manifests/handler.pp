class twlight::handler inherits twlight {

  # Import DB Dump if available
  exec { 'mysql_import':
    command   => "/usr/bin/mysql -u twlight -p${twlight_mysqltwlight_pw} -D twlight < ${twlight_mysqlimport}",
    logoutput => true,
    onlyif    => "/usr/bin/stat ${twlight_mysqlimport}",
  }

  # Reload nginx
  exec { 'nginx_reload':
    command     => '/usr/sbin/nginx -t && /bin/systemctl reload nginx',
    refreshonly => true,
  }

  # Configure virtual environment
  exec { 'virtualenv_update':
    command => "/bin/bash /var/www/html/TWLight/bin/twlight_update_code.sh",
  }

}
