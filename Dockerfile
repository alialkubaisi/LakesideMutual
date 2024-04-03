# Build stage for Spring Boot application
# build maven for customer-core, then build customer-management-backend and then build customer-management-frontend
FROM maven:3.6.3-jdk-11 AS build
COPY src /home/app/customer-core/src
COPY pom.xml /home/app/customer-core
RUN mvn -f /home/app/customer-core/pom.xml clean package

COPY src /home/app/customer-management-backend/src
COPY pom.xml /home/app/customer-management-backend
RUN mvn -f /home/app/customer-management-backend/pom.xml clean package

# Package stage with OpenJDK JRE
FROM openjdk:11-jre-slim
COPY --from=build /home/app/customer-core/target/customer-core-0.0.1-SNAPSHOT.jar /usr/local/lib/customer-core.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/usr/local/lib/customer-core.jar"]

COPY --from=build /home/app/customer-management-backend/target/customer-management-backend-0.0.1-SNAPSHOT.jar /usr/local/lib/customer-management-backend.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "/usr/local/lib/customer-management-backend.jar"]