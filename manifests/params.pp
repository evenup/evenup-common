# Class common::params
#
# Default parameters for evenup/common
#
class common::params {

  $logsagent        = undef
  $root_mail        = undef
  $clean_tmp        = false
  $clean_age        = '+30'
  $clean_paths      = '/tmp /var/tmp'
  $absent_packages  = undef
  $install_packages = undef
  $stopped_services = undef
  $absent_files     = undef

  $root_pw          = undef
  $root_ssh_key     = undef
  $root_priv_key    = undef
  $ohshit_pw        = undef
  $ohshit_key       = undef
  $absent_users     = undef
  $absent_groups    = undef

  if defined('::firewall') {
    $firewall = true
  } else {
    $firewall = false
  }

  $default_pre_rules = {
    '000 accept all icmp' => {
      proto   => 'icmp',
      action  => 'accept'
    },
    '001 accept all to lo interface' => {
      proto   => 'all',
      iniface => 'lo',
      action  => 'accept'
    },
    '002 reject local traffic not on loopback interface' => {
      iniface     => '! lo',
      proto       => 'all',
      destination => '127.0.0.1/8',
      action      => 'reject'
    },
    '003 accept related established rules' => {
      proto   => 'all',
      state => ['RELATED', 'ESTABLISHED'],
      action  => 'accept',
    }
  }

  $default_post_rules = {
    '999 drop all' => {
      proto   => 'all',
      action  => 'drop'
    }
  }
}