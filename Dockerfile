# 1단계: 빌드용 컨테이너 (Gradle + JDK 17, Ubuntu 기반)
FROM eclipse-temurin:17-jdk-jammy AS build

WORKDIR /home/app

# gradlew가 있는 Spring Boot 프로젝트 기준 (Spring Initializr로 만든 구조)
COPY gradlew gradle* ./
COPY gradle ./gradle
COPY build.gradle settings.gradle ./
COPY src ./src

RUN chmod +x gradlew
RUN ./gradlew bootJar --no-daemon

# 2단계: 실행용 컨테이너 (JRE 17, Ubuntu 기반)
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# 빌드 단계에서 생성된 jar 복사
COPY --from=build /home/app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
