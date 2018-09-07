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
    # To get the key ID, use the mariadb repository configuration tool:
    # https://downloads.mariadb.org/mariadb/repositories/#mirror=digitalocean-sfo&distro=Debian&distro_release=stretch--stretch&version=10.2
    # Grab the hex-formatted keyid from the instructions, and then search for the fingerprint:
    # https://keyserver.ubuntu.com/pks/lookup?search=INSERTAREALKEYIDHERE&fingerprint=on&op=vindex

    apt::source { 'mariadb':
      location => 'http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.2/debian',
      release  => $::lsbdistcodename,
      repos    => 'main',
      pin      => '1002',
      key      => {
        id     => '177F4010FE56CA3336300305F1656F24C74CD1D8',
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
