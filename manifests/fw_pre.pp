# Firt rules to add to list
#
class common::fw_pre (
  $rules = $::common::params::default_pre_rules,
) inherits common::params {

  if $rules {
    create_resources(firewall, $rules, { require => undef } )
  }

}