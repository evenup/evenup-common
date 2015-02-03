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
# Copyright 2014 EvenUp.
#
class common (
  $logsagent        = $::common::params::logsagent,
  $root_mail        = $::common::params::root_mail,
  $clean_tmp        = $::common::params::clean_tmp,
  $clean_age        = $::common::params::clean_age,
  $clean_paths      = $::common::params::clean_paths,
  $absent_packages  = $::common::params::absent_packages,
  $install_packages = $::common::params::install_packages,
  $stopped_services = $::common::params::stopped_services,
  $absent_files     = $::common::params::absent_files,
  $firewall         = $::common::params::firewall,
) inherits common::params {

  if $root_mail {
    $mail_ensure = 'present'
  } else {
    $mail_ensure = 'absent'
  }

  if $install_packages {
    package { $install_packages:
      ensure  => 'installed'
    }
  }

  if $absent_packages {
    package { $absent_packages:
      ensure  => 'absent',
    }
  }

  if $stopped_services {
    service { $stopped_services:
      ensure => 'stopped',
      enable => false,
    }
  }

  if $absent_files {
    file { $absent_files:
      ensure  => absent;
    }
  }

  file { '/etc/sysconfig/init':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
    source => 'puppet:///modules/common/init.sysconfig'
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

  if $firewall {
    Firewall {
      require => Class['common::fw_pre'],
      before  => Class['common::fw_post'],
    }

    include common::fw_pre
    include common::fw_post
  }

  if $clean_tmp {
    file { '/usr/local/bin/tmpclean.sh':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0555',
      content => template("${module_name}/tmpclean.sh.erb")
    }

    cron { 'tmpclean':
      ensure  => 'present',
      command => '/usr/local/bin/tmpclean.sh > /dev/null',
      user    => 'root',
      hour    => 1,
      minute  => fqdn_rand(59),
    }
  } else {
    cron { 'tmpclean': ensure => 'absent' }
  }

  case $logsagent {
    'beaver': {
      # Log monitoring for all machines
      beaver::stanza { '/var/log/messages':
        type => 'syslog',
        tags => ['messages', $::disposition],
      }

      beaver::stanza { '/var/log/secure':
        type => 'syslog',
        tags => ['secure', $::disposition],
      }

      beaver::stanza { '/var/log/sudolog':
        type => 'sudolog',
        tags => ['sudolog', $::disposition],
      }
    }
    default: {}
  }

}
