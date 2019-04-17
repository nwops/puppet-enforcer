class enforcer::tomcat(
  Array[String] $included_policies,
  Array[String] $excluded_policies,
) {
  $enforced_policies = $included_policies - $excluded_policies
  $enforced_policies.each |String $policy| {
    $klass_name = "enforcer::tomcat::${policy}"
    class{$klass_name:
      tag      => [$policy, 'policy', 'tomcat']
    }
  }
}
