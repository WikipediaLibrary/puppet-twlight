# == Class: twlight
#
# === Parameters
#
# Document parameters here.
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# === Examples
#
# === Authors
#
# Jason Sherman
#
# === Copyright
#
# Copyright 2017 Your name here, unless otherwise noted.
#

class twlight (
  String    $git_repository = $twlight::params::git_repository,
  String    $git_revision = $twlight::params::git_revision,
  String    $root_dir = $twlight::params::root_dir,
  String    $mysqlroot_pw = $twlight::params::mysqlroot_pw,
  String    $mysqltwlight_pw = $twlight::params::mysqltwlight_pw,
  String    $restore_file = $twlight::params::restore_file,
  String    $backup_dir = $twlight::params::backup_dir,
  String    $mysqldump_dir = $twlight::params::mysqldump_dir,
  String    $servername = $twlight::params::servername,
  String    $serverport = $twlight::params::serverport,
  String    $externalport = $twlight::params::externalport,
  String    $environment = $twlight::params::environment,
  String    $unixname = $twlight::params::unixname,
  Hash      $mysql_override_options = $twlight::params::mysql_override_options,
  String    $secretkey = $twlight::params::secretkey,
  String    $allowedhosts = $twlight::params::allowedhosts,
  String    $baseurl = $twlight::params::baseurl,
  String    $oauth_provider_url = $twlight::params::oauth_provider_url,
  Boolean   $package_manage = $twlight::params::package_manage,
  String    $package_ensure = $twlight::params::package_ensure,
  Array     $package_name = $twlight::params::package_name,
) inherits twlight::params {
  ##include apt
#  contain ::twlight::repo
  contain ::twlight::install
  contain ::twlight::configsys
  contain ::twlight::fetch
  contain ::twlight::configapp
  contain ::twlight::handler

#  Class['::twlight::repo'] ->
  Class['::twlight::install'] ->
  Class['::twlight::configsys'] ->
  Class['::twlight::fetch'] ->
  Class['::twlight::configapp'] ->
  Class['::twlight::handler']
}
