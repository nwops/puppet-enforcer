define enforcer::policy(
  String $policy_name = $name,
) {
  if $kernel == 'windows' {
    $ext_name = 'ps1'
    $exec_provider = 'powershell'
  } else {
    $ext_name = 'sh'
    $exec_provider = 'shell'
  }

  $enforce_script = file("enforcer/${policy_name}_enforce.${ext_name}", '/dev/null')
  $validate_script = file("enforcer/${policy_name}_validate.${ext_name}", '/dev/null')

  # if validate returns 0 (passes) no need to trigger the enforcer command
  exec{"${policy_name}_enforce":
    command  => $enforce_script,
    unless   => $validate_script,
    provider => $exec_provider,
  }

}
