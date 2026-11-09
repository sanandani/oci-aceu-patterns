# Minimal Java container on OCI with TLS to DB — worked example

Verbatim worked-example text from the matching enhanced article draft. Commands and code are retained in source order; angle-bracket values are placeholders.

Install the container tooling on Oracle Linux 8 and build on the same architecture you will run on. Building on the A1 instance avoids cross-architecture surprises.

sudo dnf module install -y container-tools:ol8

sudo dnf install -y podman-docker git

A Dockerfile that runs as a non-root user. The Temurin JRE image is published for arm64 as well as x86.

FROM eclipse-temurin:17-jre

RUN useradd --system --no-create-home appuser

WORKDIR /app

COPY target/app.jar /app/app.jar

USER appuser

CMD ["java", "-jar", "/app/app.jar"]

Run it with the password supplied as a Podman secret, and with a read-only filesystem and no extra capabilities:

printf '%s' "$DB_PASSWORD" | podman secret create db_password -

podman run -d --name app -p 8080:8080 \

--read-only --tmpfs /tmp --cap-drop=ALL \

--env JDBC_URL='<tcps_jdbc_url>' --env DB_USER='<db_user>' \

--secret db_password,type=env,target=DB_PASSWORD \

<region-key>.ocir.io/<tenancy-namespace>/myteam/myapp:1.4.2

In the application, build the pool from environment values and keep the sizes modest:

PoolDataSource pds = PoolDataSourceFactory.getPoolDataSource();

pds.setConnectionFactoryClassName("oracle.jdbc.pool.OracleDataSource");

pds.setURL(System.getenv("JDBC_URL"));          // tcps:// URL

pds.setUser(System.getenv("DB_USER"));

pds.setPassword(System.getenv("DB_PASSWORD"));

pds.setMinPoolSize(2);

pds.setMaxPoolSize(10);

pds.setValidateConnectionOnBorrow(true);

For mTLS, mount the wallet directory read-only at run time, set TNS_ADMIN to it, and let ojdbc.properties supply the wallet location. Do not copy it into the image. Remember to open the application port in both the instance firewall and the network security group.
