FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/api-service.jar /app/api-service.jar

EXPOSE 8082

CMD ["java", "-jar", "api-service.jar"] 