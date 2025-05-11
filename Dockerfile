# Build stage
FROM eclipse-temurin:17-jdk-alpine as build
WORKDIR /app

# Copy maven executable and pom.xml
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Make the maven wrapper executable
RUN chmod +x ./mvnw

# Download all dependencies
# This is done in a separate step to leverage Docker cache
RUN ./mvnw dependency:go-offline -B

# Copy the source code
COPY src src

# Build the application
RUN ./mvnw package -DskipTests
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)

# Run stage
FROM eclipse-temurin:17-jre-alpine
VOLUME /tmp
ARG DEPENDENCY=/app/target/dependency

# Copy the dependency application layer
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app

# Set environment variables
ENV SERVER_PORT=8080
# Set environment variable
ENV SPRING_PROFILES_ACTIVE=prod

# Set security options
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Run the application
ENTRYPOINT ["java", "-cp", "app:app/lib/*", "com.example.authservice.AuthServiceApplication"]