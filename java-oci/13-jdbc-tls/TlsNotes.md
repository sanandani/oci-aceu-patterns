# JDBC TLS settings

The local compose database uses plain TCP for a reproducible Oracle Free demo. For an Oracle TLS listener/wallet, use the Oracle JDBC wallet configuration, mount wallet files read-only, and set JVM properties such as `-Djavax.net.ssl.trustStore=/run/wallet/truststore.jks` and `-Djavax.net.ssl.trustStorePassword` via a runtime secret. For mTLS, configure the client key store as well. Never put wallet files or passwords in the image. TLS has not been exercised by this local-TCP fixture.
