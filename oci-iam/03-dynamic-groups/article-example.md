# Dynamic groups with tag-based scoping (illustrative patterns) — worked example

Verbatim worked-example text from the matching enhanced article draft. Commands and code are retained in source order; angle-bracket values are placeholders.

A rule that requires both the compartment and the tag. The tag here uses a namespace called department and a key called runtime.

ALL {instance.compartment.id = '<apps_compartment_ocid>',

tag.department.runtime.value = 'payments'}

When a group should cover two compartments, use ANY around the compartment checks and keep the tag condition outside it:

ALL {

ANY {instance.compartment.id = '<apps_compartment_ocid>',

instance.compartment.id = '<shared_compartment_ocid>'},

tag.department.runtime.value = 'payments'

}

The Console rule builder covers the simple cases, but you will type tag rules by hand. Changes to a rule or to a tag are not instant, so I verify the effective membership rather than assuming it, and I keep the rule text in version control next to the policy it supports.
