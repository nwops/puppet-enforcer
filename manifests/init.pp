class enforcer(
  $included_policies,
  $excluded_policies,
) {
  $enforced_policies = $included_policies - $excluded_policies
  $enforced_policies.each |String $policy| {
    # debug::break()
    enforcer::policy{$policy:
      tag      => [$policy, 'policy']
    }
  }
}
