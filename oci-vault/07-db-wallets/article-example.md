# Vault + DB wallets: secure distribution patterns (illustrative) — worked example

Verbatim worked-example text from the matching enhanced article draft. Commands and code are retained in source order; angle-bracket values are placeholders.

Generate the wallet and push the files into Vault. The CLI needs base64 content, while the Console encodes plain text for you.

oci db autonomous-database generate-wallet \

--autonomous-database-id <db_ocid> \

--file wallet.zip \

--password "<wallet_password>"

unzip wallet.zip -d wallet

base64 -w0 wallet/cwallet.sso > cwallet.sso.b64

oci vault secret create-base64 \

--compartment-id <compartment_ocid> \

--vault-id <vault_ocid> \

--key-id <symmetric_key_ocid> \

--secret-name db_wallet_cwallet_sso \

--secret-content-content "$(cat cwallet.sso.b64)" \

--secret-content-stage CURRENT

Repeat for the other files the connection needs, usually tnsnames.ora, sqlnet.ora and ojdbc.properties. At startup, the app reads each secret, decodes it and writes it into a directory only its own user can access. The sketch below shows the permission handling.

Path dir = Files.createTempDirectory("wallet",

PosixFilePermissions.asFileAttribute(PosixFilePermissions.fromString("rwx------")));

for (var e : walletSecrets.entrySet()) {          // name -> base64 content

Files.write(dir.resolve(e.getKey()), Base64.getDecoder().decode(e.getValue()));

}

// start the JVM or pool with -Doracle.net.tns_admin=<dir> or TNS_ADMIN=<dir>

The ojdbc.properties file that ships in the wallet refers to the TNS_ADMIN directory for its wallet location, so it works unchanged when you rebuild the directory.
