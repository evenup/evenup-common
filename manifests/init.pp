# == Class: common
#
# This class is the dumping ground for package and service configuration that
# should be applied to every host.
#
# === Parameters
#
# None
#
# === Examples
#
#   class { 'common': }
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
# === Copyright
#
# Copyright 2012 EvenUp.
#
class common {
  package { [ 'iftop', 'iotop', 'lsof', 'man', 'openssh-clients', 'rsync', 'screen', 'unzip', 'wget']:
    ensure  => installed;
  }

  package { 'ec2-boot-init':
    ensure  => absent;
  }

  service { 'cups':
    ensure  => stopped,
    enable  => false;
  }

  file { '/etc/init/control-alt-delete.conf':
    ensure  => absent;
  }
}
