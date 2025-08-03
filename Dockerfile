FROM openjdk:21-jdk-slim

LABEL maintainer="Ehtishamul Hassan"
LABEL version="1.0"
LABEL description="this is the springboot app with database"

WORKDIR /app

# COPY target/*.jar app.jar
COPY app.jar app.jar

EXPOSE 8080

CMD ["java" , "-jar", "app.jar"]

