# twlight_puppet

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with twlight](#setup)
    * [What twlight affects](#what-twlight-affects)
    * [Beginning with twlight](#beginning-with-twlight)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)

## Overview

This puppet module deploys and configures the [Library Card Platform for The Wikipedia Library](https://github.com/WikipediaLibrary/TWLight) to Debian 8 systems.
It is a work in progress.

## Module Description

As it stands, this module is somewhat amature attempt to puppetize TWLight.
It does the following sorts of things:
 * directly installs and configures packages
 * checks stuff out from git
 * runs dumb shell scripts to manage django
 * writes secrets to files

You probably only want to use this if you are developing or operating TWLight.

## Setup

### What twlight affects

The initial goal of this module is to install and configure TWLight as described in the project [Sysadmin docs](https://github.com/WikipediaLibrary/TWLight/blob/master/docs/sysadmin.md). Most of that doc content will get migrated here. Beyond that, this module
* Runs any uncommitted django migrations
* Imports a db dump if one exists at the specified location
* Adds a daily mysql dump cron job

### Beginning with twlight

Give [twlight_vagrant](https://github.com/WikipediaLibrary/twlight_vagrant) a go

## Usage


The classes, types, and resources for customizing, configuring, and doing
the fancy stuff with this module are all shifting around rapidly since it's very
immature.  Check out the default manifest in the vagrant environment for now.

The only intended production environment for this is the wikimedia tools infrastructure.
It's such a narrow-use module, that there's not much point in investing the effort to
split it out into role modules + scap code deployment.

So, to do a headless deploy on tools:
1. new instance on horizon, with appropriate host-specific hiera config to allow access to the project share
2. dump db on current site
3. Do a local puppet run
```
puppet module install jsnshrmn/twlight --version x.x.x
puppet apply some-manifest.pp
```
4. delete the proxy pointing to the old site
5. create a proxy pointing to a new site


## Reference

## Limitations

Debian 8 only

## Development

[twlight_vagrant](https://github.com/WikipediaLibrary/twlight_vagrant) is an adequate environment to develop this module in. Beyond the typical github workflow, you may wish to build the module to publish updates to puppet forge. You'll need to feed all of the right options to the installation of puppet in that environment, like:
```
/opt/puppetlabs/bin/puppet module build /vagrant/puppet/modules/twlight --codedir /vagrant/puppet
```

