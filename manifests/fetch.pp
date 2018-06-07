class twlight::fetch inherits twlight {

  vcsrepo { "${root_dir}":
    ensure   => present,
    provider => git,
    source   => $git_repository,
    revision => $git_revision,
  }

}
