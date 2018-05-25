class twlight::repo inherits twlight {

  if $twlight::package_manage {

    # Make sure apt can communicate via https before adding 3rd party repos
    package { 'apt-transport-https':
      ensure  => $package_ensure,
    }

    # Add Node.js 8.x repo, pinned one higher than the wiki repos.
    # But not via their provided "curl | sudo bash" mechanism
    # https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
    apt::source { 'nodesource':
      comment  => 'Node.js 8.x repo',
      location => 'https://deb.nodesource.com/node_8.x',
      release  => $::lsbdistcodename,
      repos    => 'main',
      pin      => '1002',
      key      => {
        'id'     => '9FD3B784BC1C6FC31A8A0A1C1655A0AB68576280',
        'source' => 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key',
      },
      include => {
        'src' => false,
        'deb' => true,
      },
      require => Package['apt-transport-https'],
    }

    # Add official MariaDB repo so that we can get a newer version than Debian provides.
    apt::source { 'mariadb':
      location => 'http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.2/debian',
      release  => $::lsbdistcodename,
      repos    => 'main',
      pin      => '1002',
      key      => {
        id     => '199369E5404BD5FC7D2FE43BCBCB082A1BB943DB',
        server => 'hkp://keyserver.ubuntu.com:80',
      },
      include => {
        src   => false,
        deb   => true,
      },
      require => Package['apt-transport-https'],
    }
  }
}
