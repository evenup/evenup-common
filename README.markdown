#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with common](#setup)
    * [What common affects](#what-common-affects)
    * [Beginning with common](#beginning-with-common)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Changelog/Contributors](#changelog-contributors)

## Overview

Puppet module to manage packages and services not worth an entire module.  It can also remove files, users, and groups as well as configure a backup user.

## Module Description

There are a wide range of packages, services, users, and groups that are installed as part of a distribution's installation that are not
relevant to your configuration and should be cleaned up.

Many installations also use a centralized directory server for authentication and authorization.  If there is a configuration issue on
an individual server it may no longer be able to validate credentials with the centralized directory server.  This module also supports
installing a backup user which can be used in that eventuality.

## Setup

### What common affects

By default, this module only installs a slightly updated command prompt and secures the console for cloud machines.

### Beginning with common

This module can be installed with
```
    puppet module install evenup-common
```

## Usage

Ensure the wget and curl packages are installed:

```
    class { 'common':
      install_packages => [ 'wget', 'curl' ],
    }
```

Ensure the telnet package is absent:

```
    class { 'common':
      absent_packages => 'telnet',
    }
```

Ensure the tape group is absent

```
    class { 'common::users':
      absent_groups => 'tape'
    }
```


## Reference

### Classes

#### Public Classes

* `common`: Manages packages and services
* `common::users`: Manages users and groups

## Limitations

Only tested on CentOS/RHEL

## Development

Improvements and bug fixes are greatly appreciated.  See the [contributing guide](https://github.com/evenup/evenup-common/CONTRIBUTING.md) for
information on adding and validating tests for PRs.

## Changelog / Contributors

[Changelog](https://github.com/evenup/evenup-common/CHANGELOG)
[Contributors](https://github.com/evenup/evenup-common/graphs/contributors)
