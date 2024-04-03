# build spring boot application from customer-core and customer-management-backend
# and create a docker image
# Use a base image with Java and Maven installed

FROM maven:3.8.4-openjdk-11-slim AS builder

# Set the working directory
WORKDIR /app

# Copy the pom.xml files
COPY customer-core/pom.xml customer-core/
COPY customer-management-backend/pom.xml customer-management-backend/

# Build the dependencies
RUN mvn -B dependency:go-offline -f customer-core/pom.xml
RUN mvn -B dependency:go-offline -f customer-management-backend/pom.xml

# Copy the source code
COPY customer-core/src customer-core/src
COPY customer-management-backend/src customer-management-backend/src

# Build the applications
RUN mvn -B clean package -DskipTests -f customer-core/pom.xml
RUN mvn -B clean package -DskipTests -f customer-management-backend/pom.xml

# Use a lightweight base image with Java installed
FROM adoptopenjdk:11-jre-hotspot

# Set the working directory
WORKDIR /app

# Copy the JAR files from the builder stage
COPY --from=builder /app/customer-core/target/customer-core-0.0.1-SNAPSHOT.jar .
COPY --from=builder /app/customer-management-backend/target/customer-management-backend-0.0.1-SNAPSHOT.jar .

# Expose the necessary ports
EXPOSE 8080

# Set the entrypoint command to run the applications
CMD ["java", "-jar", "customer-core-0.0.1-SNAPSHOT.jar"]

CMD ["java", "-jar", "customer-management-backend-0.0.1-SNAPSHOT.jar"]

# Build the frontend application
# Use a base image with Node.js installed

FROM node:16.13.0 AS frontend
# Set the working directory
WORKDIR /app
# Copy the package.json and package-lock.json files
COPY customer-management-frontend/package*.json .
# Install the dependencies
RUN npm install
# Copy the source code
COPY customer-management-frontend .

# Build the application
RUN npm run build
FROM nginx:1.21.3
COPY --from=frontend /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]