# enforcer

## Summary

Applies security policies to system based on included/excluded policies.

## Usage

There are two ways to use the module.

- enforce all the generic system level policies that can be run without further modification
- enforce application specific policies that require some application to be installed first

### OS Level

`include enforcer`

### Application Specific

`include enforcer::tomcat`

## Unit testing

`bundle exec rake spec`

## Acceptance Testing

Testing of this code is done via test kitchen and inspec. At this time there are no valid tests. However the kitchen file was create for future use.

`kitchen test`

## Including / Excluding Security Policies

Custom policy selection is enforced via hiera data at the module and other tiers. By default
the module tier will set the initial defaults unless otherwise specified in global or environment tiers.

You can exclude certain policies by simpling adding the policy number to the exclusion list or by ommitting them entirely from the inclusion list.

```yaml
enforcer::excluded_policies:
  - pol101

enforcer::tomcat::excluded_policies:
  - pol102
```

Conversely, you can include policies by adding them to the list. Any policy that exist in both lists will not be present in the resultant set.

```yaml
enforcer::tomcat::included_policies:
  - pol101
  - pol102
enforcer::included_policies:
  - pol101
  - pol102
  - pol103
```

### Special Merge Behavior

Policy lists will be merged together across all hiera levels to allow for simpler inclusion/exclusion lists. This means that if a exclusion or inclusion list exists in more than
one level for a hiera lookup, that list will be merge together. This might be useful for datacenter, node and app levels.

```yaml
lookup_options:
  enforcer::included_policies:
    merge: unique
  enforcer::excluded_policies:
    merge: unique
  enforcer::included_policies::tomcat:
    merge: unique
  enforcer::excluded_policies::tomcat:
    merge: unique
```
