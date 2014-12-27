# Moved to their own class to set stage
class common::users (
  $root_pw       = $::common::params::root_pw,
  $root_ssh_key  = $::common::params::root_ssh_key,
  $root_priv_key = $::common::params::root_priv_key,
  $ohshit_pw     = $::common::params::ohshit_pw,
  $ohshit_key    = $::common::params::ohshit_key,
  $absent_users  = $::common::params::absent_users,
  $absent_groups = $::common::params::absent_groups,
) inherits common::params {

  if $root_pw {
    account { 'root':
      home_dir => '/root',
      password => $root_pw,
      ssh_key  => $root_ssh_key,
    }
  }

  if $root_priv_key {
    file { '/root/.ssh/id_rsa':
      ensure => 'file',
      owner  => 'root',
      group  => 'root',
      mode   => '0400',
      source => $root_priv_key,
    }
  }

  if $ohshit_pw {
    account { 'ohshit':
      ensure       => 'present',
      comment      => 'Emergency Backup User',
      create_group => true,
      groups       => [ 'wheel' ],
      password     => $ohshit_pw,
      home_dir     => '/home/.ohshit',
      shell        => '/bin/bash',
      manage_home  => true,
      ssh_key      => $ohshit_key,
      system       => true,
    }
  }

  if $absent_users and $absent_groups {
    user { $absent_users:
      ensure => 'absent',
    } ->
    group { $absent_groups:
      ensure => 'absent'
    }
  } elsif $absent_users {
    user { $absent_users:
      ensure => 'absent',
    }
  } elsif $absent_groups {
    group { $absent_groups:
      ensure => 'absent'
    }
  }

}
