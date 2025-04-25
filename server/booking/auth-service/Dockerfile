FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/auth-service.jar /app/auth-service.jar

EXPOSE 8081

CMD ["java", "-jar", "auth-service.jar"] 