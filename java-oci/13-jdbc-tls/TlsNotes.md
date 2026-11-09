# JDBC TLS settings

The article’s wallet-backed UCP code and `NETWORK_PROTOCOL` verification are in [article-example.md](article-example.md). The local Oracle Free compose listener uses plain TCP so the integration demo remains runnable without a wallet. For a TLS endpoint, use the wallet TNS alias from `tnsnames.ora`, set `TNS_ADMIN` (or `-Doracle.net.tns_admin`), retain certificate name checking, and inject `DB_USER`/`DB_PASSWORD` at startup. The wallet's `ojdbc.properties` supplies wallet location for mTLS. Never commit wallet files or passwords. The local TCP fixture does not verify TLS.
