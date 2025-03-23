# 1. Java 21 기반 빌드 환경 Test
FROM openjdk:21-slim AS build

# 기본 패키지 설치
RUN apt-get update && apt-get install -y bash

# 작업 디렉토리 설정
WORKDIR /app

# Gradle Wrapper 복사 및 실행 권한 부여
COPY gradlew .
RUN chmod +x gradlew

# Gradle 캐시 최적화: 먼저 `dependencies`만 설치 (빌드 속도 향상)
COPY build.gradle settings.gradle .
COPY gradle/ gradle/
RUN ./gradlew dependencies --no-daemon

# 소스 코드 복사 후 빌드
COPY src src
RUN ./gradlew clean build -x test --no-daemon

# 2. 실행 환경 (최소한의 Java 런타임만 포함)
FROM openjdk:21-slim

WORKDIR /app

# 빌드된 JAR 파일 복사
COPY --from=build /app/build/libs/marimo-0.0.1-SNAPSHOT.jar app.jar


# 환경 변수 설정 및 애플리케이션 실행
ENTRYPOINT ["java", "-Dspring.profiles.active=dev", "-Duser.timezone=Asia/Seoul", "-jar", "app.jar"]
