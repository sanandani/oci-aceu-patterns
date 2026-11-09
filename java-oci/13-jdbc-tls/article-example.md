# JDBC/UCP to Oracle over TLS or mTLS with wallets — worked example

Verbatim worked-example text from the matching enhanced article draft. Commands and code are retained in source order; angle-bracket values are placeholders.

With a wallet, point the driver at the directory that holds it and use the alias as the connection target. The ojdbc.properties file in the wallet supplies the wallet location.

// TNS_ADMIN is set outside the code (environment or -Doracle.net.tns_admin)

PoolDataSource pds = PoolDataSourceFactory.getPoolDataSource();

pds.setConnectionFactoryClassName("oracle.jdbc.pool.OracleDataSource");

pds.setURL("jdbc:oracle:thin:@dbname_high");   // alias from tnsnames.ora

pds.setUser(System.getenv("DB_USER"));

pds.setPassword(System.getenv("DB_PASSWORD"));  // injected, not hard-coded

pds.setMinPoolSize(2);

pds.setMaxPoolSize(10);

pds.setValidateConnectionOnBorrow(true);

Then prove that the connection really is encrypted, instead of assuming it:

try (var c = pds.getConnection();

var s = c.createStatement();

var rs = s.executeQuery(

"SELECT sys_context('USERENV','NETWORK_PROTOCOL') FROM dual")) {

rs.next();

System.out.println(rs.getString(1));   // expect: tcps

}

The aliases in a downloaded wallet normally include a server certificate name check. Leave it on. If you use an auto-login wallet file with an older driver, you may also need the Oracle PKI jars on the classpath, so check the driver documentation for the version you run.
