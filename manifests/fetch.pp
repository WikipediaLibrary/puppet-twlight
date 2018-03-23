class twlight::fetch inherits twlight {

  vcsrepo { "${twlight_root_dir}":
    ensure   => present,
    provider => git,
    source   => $twlight_git_repository,
    revision => $twlight_git_revision,
  }

}
