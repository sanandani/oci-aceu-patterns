# Compartment design and movement: policy implications — worked example

Verbatim worked-example text from the matching enhanced article draft. Commands and code are retained in source order; angle-bracket values are placeholders.

Take a move from A:B:C to A:D. Policies written at A, the common ancestor, keep working and update their path references. A policy attached inside B that named C by path no longer matches its target, and the access it granted disappears until someone rewrites it.

# Attached at A (the shared ancestor): survives the move

Allow group TeamA-Admins to manage all-resources in compartment A:Prod

Allow group TeamA-Users  to use instance-family in compartment A:Dev

# Attached inside A:B and naming C by path: must be reviewed after the move

Allow group TeamC to use instance-family in compartment A:B:C

Before a move, list the policies that mention the compartment and note which ancestor each is attached to. After the move, check access with a test user for each group. Quotas and budgets are set per compartment, so confirm them too.
