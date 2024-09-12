# Build the application

# Packages necessary to build spring boot application
FROM maven:3.8.6-openjdk-17 AS build

# Add relevant pom.xml file and copy application source code
COPY pom.xml /build
COPY src /build/src

# Set working directoy
WORKDIR /build

# Add dependency for offline usage and package it
RUN mvn dependency:go-offline
RUN mvn clean package -DskipTests

# Runtime image

# JDK for running the application
FROM openjdk:17-jdk-runtime

# Set working directory
WORKDIR /app

# Copy built jar file here
COPY --from=build /build/target/app.jar /app/

# Expose the port for application for Spring bot application
EXPOSE 8080

# Execute the application
ENTRYPOINT ["java", "-jar", "app.jar"]

