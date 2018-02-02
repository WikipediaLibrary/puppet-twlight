class twlight::fetch inherits twlight {

  vcsrepo { '/var/www/html/TWLight':
    ensure   => present,
    provider => git,
    source   => $twlight_git_repository,
    revision => $twlight_git_revision,
  }

}
