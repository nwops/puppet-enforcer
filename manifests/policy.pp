define enforcer::policy(
  $ext_name,
  $policy_name = $name,

) {
  debug::break()
  $enforce_script = file("modules/enforcer/files/${policy_name}_enforce.${ext_name}")
  $validate_script = file("modules/enforcer/files/${policy_name}_validate.${ext_name}")

  exec{"${policy_name}_validate":
    command => $validate_script,
    notify  => Exec["${policy_name}_enforce"]
  } 

  # sometimes the enforce script takes a very long time to run
  # so only do this if we must
  exec{"${policy_name}_enforce":
    command => $enforce_script,
    refreshonly => true
  } 
  
}