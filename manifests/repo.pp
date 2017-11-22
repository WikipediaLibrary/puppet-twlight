class twlight::repo inherits twlight {

  if $twlight::package_manage {

    # Make sure apt can communicate via https before adding 3rd party repos
    package { 'apt-transport-https':
      ensure  => $package_ensure,
    }

    # Install Node.js 8.x
    # But not via their provided "curl | sudo bash" mechanism
    # https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
    apt::source { 'nodesource':
      comment  => 'Node.js 8.x repo',
      location => 'https://deb.nodesource.com/node_8.x',
      release  => 'jessie',
      repos    => 'main',
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
  }
}
