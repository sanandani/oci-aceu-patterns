# Least-privilege IAM policies for workloads (compartment-first) — worked example

Verbatim worked-example text from the matching enhanced article draft. Commands and code are retained in source order; angle-bracket values are placeholders.

Here is the shape I aim for with an application compartment called apps. Runtime access is narrow, and the platform team gets a separate, more powerful statement.

# Runtime: what the app itself needs

Allow dynamic-group app-runtimes to read objects in compartment apps

where target.bucket.name = 'app-config'

Allow dynamic-group app-runtimes to use log-content in compartment apps

# Operators: separate group, separate statements

Allow group platform-admins to manage instance-family in compartment apps

Allow group platform-admins to read policies in compartment apps

Compare that with what usually shows up in a review:

Allow group developers to manage all-resources in tenancy

The second line is shorter and works on day one, which is why it keeps appearing. It is also impossible to explain to an auditor. When delegating to a sub-team, use a compartment path such as A:B so the grant follows the hierarchy.

Be careful with the ability to manage policies. Whoever can manage policies in a compartment can usually grant themselves more, so I keep that permission with a very small group.
