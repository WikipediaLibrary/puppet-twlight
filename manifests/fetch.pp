class twlight::fetch inherits twlight {

  vcsrepo { '/var/www/html/TWLight':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/WikipediaLibrary/TWLight.git',
  }
}