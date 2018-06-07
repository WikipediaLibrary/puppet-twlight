# == Class: twlight
#
# Full description of class twlight here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream twlight servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_twlight_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'twlight':
#    servers => [ 'pool.twlight.org', 'twlight.local.company.com' ],
#  }
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

  $package_manage = $twlight::params::package_manage,
  $package_ensure = $twlight::params::package_ensure,
  $package_name = $twlight::params::package_name,
) inherits twlight::params {

  validate_bool($package_manage)
  validate_string($package_ensure)
  validate_array($package_name)

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'twlight::begin': } ->
  class { '::twlight::repo': } ->
  class { '::twlight::install': } ->
#  class { '::twlight::tidymariadb': } ->
  class { '::twlight::configsys': } ->
  class { '::twlight::fetch': } ->
  class { '::twlight::configapp': } ->
  class { '::twlight::handler': } ->
  anchor { 'twlight::end': }
}

