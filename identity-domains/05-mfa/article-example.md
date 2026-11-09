# Identity Domains: MFA policies and admin-safe rollout — worked example

Verbatim worked-example text from the matching enhanced article draft. Commands and code are retained in source order; angle-bracket values are placeholders.

The rollout order I use. Rule order matters, because sign-on rules are evaluated from the top.

1. Enable factors: FIDO2/passkey, mobile app notification/passcode.

Generate a bypass code and store it somewhere offline.

2. Open the sign-on policy for the console (or create one).

3. Rule 1 (top):  group = Administrators  -> require MFA

Rule 2:        all users                -> require MFA

4. Exclude ONE named admin while you test. Keep a second session open.

5. Sign in with a private browser window as an admin and as a normal user.

6. Remove the exclusion. Re-test enrollment and re-authentication.

7. Confirm service accounts and automation use API keys or a client

application, not interactive user sign-in.

Before you flip enforcement, check that you can still reach the tenancy through a path that does not depend on the new rule, such as a confidential application that calls the REST API.
