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
    user { 'root':
      home           => '/root',
      comment        => 'root Puppet-managed User',
      password       => $root_pw,
      purge_ssh_keys => true,
    }
  }

  if $root_ssh_key {
    ssh_authorized_key { 'root':
      type => 'ssh-rsa',
      name => 'root SSH Key',
      user => 'root',
      key  => $root_ssh_key,
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
    group { 'ohshit':
      system => true,
    }

    user { 'ohshit':
      comment        => 'Emergency Backup User',
      home           => '/home/.ohshit',
      password       => $ohshit_pw,
      gid            => 'ohshit',
      groups         => [ 'wheel' ],
      purge_ssh_keys => true,
      system         => true,
      managehome     => true,
    }

    ssh_authorized_key { 'ohshit':
      type => 'ssh-rsa',
      name => 'ohshit SSH Key',
      user => 'ohshit',
      key  => $ohshit_key,
    }
  }

  if $absent_users and $absent_groups {
    user { $absent_users:
      ensure => 'absent',
    } ->
    group { $absent_groups:
      ensure => 'absent',
    }
  } elsif $absent_users {
    user { $absent_users:
      ensure => 'absent',
    }
  } elsif $absent_groups {
    group { $absent_groups:
      ensure => 'absent',
    }
  }

}
