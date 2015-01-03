# Last rules to add to firewall
#
class common::fw_post (
  $rules = $::common::params::default_post_rules,
) inherits common::params {

  if $rules {
    create_resources(firewall, $rules, {before => undef})
  }

}