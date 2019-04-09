class enforcer(
  $included_policies,
  $excluded_policies,
  $ext_name,
) {
  $enforced_policies = $included_policies - $excluded_policies

  $enforced_policies.each |String $policy| {
    enforcer::policy{$policy:
    ext_name => $ext_name,
    tags => [$policy, 'policy']
    }

  }
}