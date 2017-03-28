class twlight::handler inherits twlight {

  # Import DB Dump if available
  exec { 'mysql_import':
    command     => "/usr/bin/mysql -u twlight -p${twlight_mysqltwlight_pw} -D twlight < ${twlight_mysqlimport}",
    logoutput   => true,
    onlyif      => "/usr/bin/stat ${twlight_mysqlimport}",
  }

  # Reload nginx
  exec { 'nginx_reload':
    command     => "/usr/sbin/nginx -t && /bin/systemctl reload nginx",
    refreshonly => true,
  }

  # Start gunicorn
  # 30 second delay is a kludge that made gunicorn worky, at least in vagrant
  exec { 'gunicorn_start':
    command     => "/bin/bash -c '/bin/sleep 30 && /bin/systemctl start gunicorn' &",
    unless      => '/usr/bin/stat /var/www/html/TWLight/run/gunicorn.sock',
  }

}
