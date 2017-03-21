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
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class twlight (
  $package_manage = $twlight::params::package_manage,
  $package_ensure = $twlight::params::package_ensure,
  $package_name = $twlight::params::package_name,
) inherits twlight::params {

  validate_bool($package_manage)
  validate_string($package_ensure)
  validate_array($package_name)

  include 'nginx'

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'twlight::begin': } ->
  class { '::twlight::install': } ->
  class { '::twlight::configsys': } ->
  class { '::twlight::fetch': } ->
  class { '::twlight::configapp': } ->
  anchor { 'twlight::end': }
}

