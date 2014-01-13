# == Class: common
#
# This class is the dumping ground for package and service configuration that
# should be applied to every host.
#
# === Parameters
#
# [*logsagent*]
#   String.  Agent used to ship standard syslog files
#   Default: ''
#   Valid options: beaver
#
# [*root_mail*]
#   String.  Recipient of root's mail.  Undef is to remove the alias
#   Default: undef
#
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
class common (
  $logsagent    = '',
  $root_mail    = undef,
){

  if $root_mail {
    $mail_ensure = 'present'
  } else {
    $mail_ensure = 'absent'
  }

  package { [ 'bash-completion', 'iftop', 'iotop', 'lsof', 'man', 'openssh-clients', 'rsync', 'screen', 'unzip', 'wget']:
    ensure  => installed;
  }

  package { 'ec2-boot-init':
    ensure  => absent;
  }

  service { [ 'cups', 'messagebus', 'netfs', 'portreserve' ]:
    ensure  => stopped,
    enable  => false,
  }

  file { '/etc/init/control-alt-delete.conf':
    ensure  => absent;
  }

  file { '/etc/sysconfig/init':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    source  => 'puppet:///modules/common/init.sysconfig'
  }

  file { '/etc/profile.d/ps1.sh':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0555',
    content => template('common/ps1.sh.erb'),
  }

  mailalias { 'root':
    ensure    => $mail_ensure,
    recipient => $root_mail,
    notify    => Exec['common_newaliases'],
  }

  exec { 'common_newaliases':
    command     => '/usr/bin/newaliases',
    refreshonly => true,
  }

  case $logsagent {
    'beaver': {
      # Log monitoring for all machines
      beaver::stanza { '/var/log/messages':
        type    => 'syslog',
        tags    => ['messages', $::disposition],
      }

      beaver::stanza { '/var/log/secure':
        type    => 'syslog',
        tags    => ['secure', $::disposition],
      }

      beaver::stanza { '/var/log/sudolog':
        type    => 'sudolog',
        tags    => ['sudolog', $::disposition],
      }
    }
    default: {}
  }

}
