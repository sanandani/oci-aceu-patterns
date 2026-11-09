# UCP pool tuning for resilience and validation — worked example

Verbatim worked-example text from the matching enhanced article draft. Commands and code are retained in source order; angle-bracket values are placeholders.

Start from the database's limit and work backwards. If a database can comfortably serve 200 sessions for this application and you run 8 service instances, a maximum of 20 per instance already reaches 160, which leaves room for failover and administration.

PoolDataSource pds = PoolDataSourceFactory.getPoolDataSource();

pds.setConnectionFactoryClassName("oracle.jdbc.pool.OracleDataSource");

pds.setURL("<jdbc_url>");

pds.setUser(System.getenv("DB_USER"));

pds.setPassword(System.getenv("DB_PASSWORD"));

// Sizing

pds.setInitialPoolSize(2);

pds.setMinPoolSize(2);

pds.setMaxPoolSize(20);

// Resilience

pds.setValidateConnectionOnBorrow(true);

pds.setSecondsToTrustIdleConnection(5);   // skip re-validation for 5 s

pds.setConnectionWaitTimeout(3);          // seconds a caller waits for a connection

pds.setInactiveConnectionTimeout(300);    // release idle connections after 5 min

To watch the pool, log the borrowed and available counts on a timer, or expose them through JMX:

log.info("ucp borrowed={} available={}",

pds.getBorrowedConnectionsCount(),

pds.getAvailableConnectionsCount());

If borrowed stays close to the maximum and callers start timing out, the first suspect is a slow query or a leaked connection, not the pool size.
