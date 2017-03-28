class twlight::handler inherits twlight {

  # Reload nginx
  exec { 'nginx_reload':
    command     => "/usr/sbin/nginx -t && /bin/systemctl reload nginx",
    refreshonly => true,
  }

  # Init gunicorn
  exec { 'gunicorn_start':
    command     => "/var/www/html/TWLight/bin/gunicorn_start.sh >>/var/log/gunicorn.log 2>>/var/log/gunicorn.err &",
    creates     => "/var/www/html/TWLight/run/gunicorn.sock"
  }

}
