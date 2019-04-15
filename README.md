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

## Creating a new policy

In order to create a new policy you need a few things:

1. policy number
2. application or operating system scope
3. how to enforce
4. how to validate

Once you have these items you can generate puppet code in the following ways.

### Generic defined type policy

This method is the simplest of the two and actually requires no puppet coding. Simply create
the associated OS specific validate and enforce scripts and place them in the files directory.

The file names **MUST BE NAMED ACCORDINGLY**
`<policyname><enforce_or_validate>.<script_extension>`

The enforce script will enforce the policy while the validate script will validate the system has the policy enforced. Each script must return a 0 or 1 upon success/failure.

```
files
├── pol101_enforce.ps1
├── pol101_enforce.sh
├── pol101_validate.ps1
├── pol101_validate.sh
├── pol102_enforce.ps1
├── pol102_enforce.sh
├── pol102_validate.ps1
├── pol102_validate.sh
├── pol103_enforce.ps1
├── pol103_enforce.sh
├── pol103_validate.ps1
└── pol103_validate.sh
```

Creating these files
alone does not enforce the policy on the system as you must also add the policy number to the list
of included policies in hieradata.

```yaml
enforcer::included_policies:
  - pol101
```

### Application or complex policy

Some policies will require more than a simple script to enforce. For this reason we will
need to create unique classes for each policy with additional resources in each class. This will often be more time consuming up front but also offer better idempotent puppet runs.

For each application or policy type you will need to create a base class with two parameters and similar code to create the enforced_policies:

```ruby
class enforcer::tomcat(
  Array[String] $included_policies,
  Array[String] $excluded_policies,
){
  $enforced_policies = $included_policies - $excluded_policies
  $enforced_policies.each |String $policy| {
    $klass_name = "enforcer::tomcat::${policy}"
    class{$klass_name:
      tag      => [$policy, 'policy', 'tomcat']
    }
  }
}

```

This base class will subtract the excluded from the included policies and then declare
all the policy classes for that policy type. You will need to create a puppet class that specifically enforces that policy like so.

```ruby
class enforcer::tomcat::tom101(

) {
  file{'/tmp/tom101.txt': ensure => present}

}

```
