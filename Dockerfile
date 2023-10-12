FROM openjdk:17-jdk-alpine

LABEL APPLICATION="Demo Devsu"

WORKDIR /usr/app

COPY target/demo-0.0.1.jar demo-0.0.1.jar

ENTRYPOINT ["java","-jar","demo-0.0.1.jar"]

EXPOSE 8000

HEALTHCHECK --interval=60s --retries=5 --start-period=5s --timeout=10s CMD wget --no-verbose --tries=1 --spider localhost:8000/api/actuator/health || exit 1