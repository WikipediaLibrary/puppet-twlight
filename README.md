# twlight_puppet

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with twlight](#setup)
    * [What twlight affects](#what-twlight-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with twlight](#beginning-with-twlight)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

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

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled,
etc.), mention it here.

### Beginning with twlight

Give [twlight_vagrant](https://github.com/WikipediaLibrary/twlight_vagrant) a go

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

Debian 8 only

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You may also add any additional sections you feel are
necessary or important to include here. Please use the `## ` header.
