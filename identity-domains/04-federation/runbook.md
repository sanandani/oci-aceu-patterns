# Manual verification: federation

1. In OCI Identity Domains, add the external SAML/OIDC identity provider using issuer/metadata values from a test IdP.
2. Map one synthetic test group's assertion to a least-privilege domain group.
3. Test sign-in with a non-administrator account and verify denial outside the mapped group.
4. Keep a separate break-glass administrator and verify recovery before enabling broad enforcement.
5. Record tested-on date and screenshots outside this repository; do not commit identity assertions or tenant IDs.
