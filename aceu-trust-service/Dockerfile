FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /src
COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline
COPY src ./src
RUN mvn -q -DskipTests package
FROM eclipse-temurin:21-jre
WORKDIR /app
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
COPY --from=build /src/target/aceu-trust-service-1.0.0.jar /app/service.jar
USER 10001
EXPOSE 8080
ENTRYPOINT ["java","-XX:MaxRAMPercentage=70","-jar","/app/service.jar"]
