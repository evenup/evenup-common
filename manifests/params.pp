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

}