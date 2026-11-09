# Practical secrets with OCI Vault: creation, rotation, and usage — worked example

Verbatim worked-example text from the matching enhanced article draft. Commands and code are retained in source order; angle-bracket values are placeholders.

Reading a secret from Java with an instance principal. Secret content comes back base64 encoded, so decode it and keep it in memory.

var provider = InstancePrincipalsAuthenticationDetailsProvider.builder().build();

try (var secrets = SecretsClient.builder().build(provider)) {

var req = GetSecretBundleRequest.builder()

.secretId(System.getenv("DB_SECRET_OCID"))

.stage(GetSecretBundleRequest.Stage.Current)

.build();

var content = (Base64SecretBundleContentDetails)

secrets.getSecretBundle(req).getSecretBundle().getSecretBundleContent();

byte[] password = java.util.Base64.getDecoder().decode(content.getContent());

// use the bytes, then discard them; do not log them

}

The policy that lets only the runtime read that one secret:

Allow dynamic-group app-runtimes to read secret-bundles in compartment apps

where target.secret.id = '<db_secret_ocid>'

Rotation can be configured on the secret with an interval, or driven through a function that updates the target system, such as an Autonomous Database user, and then writes a new secret version. Because every version has a stage such as current or previous, you can roll back by pointing readers at the earlier version while you investigate.
