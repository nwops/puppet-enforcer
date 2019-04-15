class tomcat(
  $included_policies,
  $excluded_policies,
) {
  $enforced_policies = $included_policies - $excluded_policies
    $enforced_policies.each |String $policy| {
      $klass_name = "tomcat::${policy}"
      class{$klass_name:
        tag      => [$policy, 'policy', 'tomcat']
      }
    }
}
