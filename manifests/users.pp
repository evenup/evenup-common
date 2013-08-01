# Moved to their own class to set stage
class common::users (
  $root_pw    = undef,
  $ohshit_pw  = undef,
  $ohshit_key = undef,
){

  if $root_pw {
    account { 'root':
      home_dir  => '/root',
      password  => $root_pw,
    }
  }

  if $ohshit_pw {
    account { 'ohshit':
      ensure        => 'present',
      comment       => 'Emergency Backup User',
      uid           => '999',
      create_group  => true,
      groups        => [ 'wheel' ],
      password      => $ohshit_pw,
      home_dir      => '/home/.ohshit',
      shell         => '/bin/bash',
      manage_home   => true,
      ssh_key       => $ohshit_key,
    }
  }

  # Clean users/groups  Easiest way to make sure users before groups, just chain them
  user { 'bin': ensure => 'absent'} ->
  user { 'games': ensure => 'absent'} ->
  user { 'gopher': ensure => 'absent'} ->
  user { 'uucp': ensure => 'absent'} ->
  user { 'adm': ensure => 'absent'} ->
  user { 'lp': ensure => 'absent'} ->
  user { 'shutdown': ensure => 'absent'} ->
  user { 'halt': ensure => 'absent'} ->
  user { 'mail': ensure => 'absent'} ->
  user { 'sync': ensure => 'absent'} ->
  user { 'ftp': ensure => 'absent'} ->
  user { 'vcsa': ensure => 'absent'} ->
  group { 'adm': ensure => 'absent'} ->
  group { 'lp': ensure => 'absent'} ->
  group { 'news': ensure => 'absent'} ->
  group { 'uucp': ensure => 'absent'} ->
  group { 'games': ensure => 'absent'} ->
  group { 'dip': ensure => 'absent'} ->
  group { 'popusers': ensure => 'absent'} ->
  group { 'video': ensure => 'absent'} ->
  group { 'ftp': ensure => 'absent'} ->
  group { 'audio': ensure => 'absent'} ->
  group { 'floppy': ensure => 'absent'} ->
  group { 'vcsa': ensure => 'absent'} ->
  group { 'cdrom': ensure => 'absent'} ->
  group { 'tape': ensure => 'absent'} ->
  group { 'dialout': ensure => 'absent'}

}
