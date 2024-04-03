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
COPY customer-management-frontend /app/customer-management-frontend
WORKDIR /app/customer-management-frontend
RUN npm install
RUN npm run build

# Serve the frontend application
FROM nginx:latest
COPY --from=builder /app/customer-management-frontend/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]