# Identity Domains: SAML/OIDC federation setup notes — worked example

Verbatim worked-example text from the matching enhanced article draft. Commands and code are retained in source order; angle-bracket values are placeholders.

The sequence I follow in the Console. It is a checklist, not a script, because the exact screens differ a little between tenancies.

1. Keep a local break-glass admin that does NOT use the new IdP.

2. Identity Domains > Security > Identity providers > Add SAML IdP.

- Upload the IdP metadata XML (or enter the endpoints and signing cert).

- Choose the attribute that carries the username (NameID or email).

3. Export the domain's service provider metadata and import it into the IdP.

4. Map IdP groups to IAM groups (group mapping / JIT provisioning).

5. Add the IdP to an identity provider policy rule and activate it.

6. Test: non-admin user first, then an admin. Confirm group-based access.

7. Record the metadata expiry date and who owns the mapping table.

For Entra ID the pattern is the same. You create an enterprise application, upload the service provider metadata, download the federation metadata XML and import it into the domain. OIDC-based identity providers follow the same ideas, with a client ID and secret in place of metadata files.
