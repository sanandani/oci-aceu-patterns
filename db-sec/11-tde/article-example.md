# TDE quickstart and keystore hygiene — worked example

Verbatim worked-example text from the matching enhanced article draft. Commands and code are retained in source order; angle-bracket values are placeholders.

Configure the keystore location. WALLET_ROOT is a static parameter, so it needs a restart. TDE_CONFIGURATION can then be set dynamically.

ALTER SYSTEM SET WALLET_ROOT = '/u01/app/oracle/admin/ORCL/wallet' SCOPE = SPFILE;

-- restart the instance, then:

ALTER SYSTEM SET TDE_CONFIGURATION = 'KEYSTORE_CONFIGURATION=FILE' SCOPE = BOTH;

Create and open the keystore, back it up, then create the master key and an auto-login keystore so the database can reopen after a restart:

ADMINISTER KEY MANAGEMENT CREATE KEYSTORE IDENTIFIED BY "<password>";

ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY "<password>";

ADMINISTER KEY MANAGEMENT BACKUP KEYSTORE USING 'before_first_key' IDENTIFIED BY "<password>";

ADMINISTER KEY MANAGEMENT SET KEY IDENTIFIED BY "<password>" WITH BACKUP;

ADMINISTER KEY MANAGEMENT CREATE AUTO_LOGIN KEYSTORE FROM KEYSTORE IDENTIFIED BY "<password>";

Create an encrypted tablespace, or convert an existing one online on Oracle Database 12.2 and later, then verify:

CREATE TABLESPACE secure_ts DATAFILE '<path>' SIZE 100M

ENCRYPTION USING 'AES256' DEFAULT STORAGE (ENCRYPT);

ALTER TABLESPACE users ENCRYPTION ONLINE USING 'AES256' ENCRYPT;

SELECT wrl_type, status, wallet_type FROM v$encryption_wallet;

SELECT ts#, encryptedts FROM v$encrypted_tablespaces;

Defaults differ between releases, and multitenant databases add container-level options, so check the TDE documentation for your version before running any of this.
