FROM openjdk:21-slim AS build

RUN apt-get update && apt-get install -y bash

WORKDIR /app

COPY gradlew .
RUN chmod +x gradlew

COPY build.gradle settings.gradle .
COPY gradle/ gradle/
RUN ./gradlew dependencies --no-daemon

COPY src src
RUN ./gradlew clean build -x test --no-daemon

FROM openjdk:21-slim

WORKDIR /app

COPY --from=build /app/build/libs/marimo-0.0.1-SNAPSHOT.jar app.jar

ENTRYPOINT ["java", "-Dspring.profiles.active=dev", "-Duser.timezone=Asia/Seoul", "-jar", "app.jar"]
