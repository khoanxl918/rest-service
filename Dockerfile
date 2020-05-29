FROM openjdk:13-jdk-alpine as build
WORKDIR /workspace/app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN ./mvnw install -DskipTests
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)

FROM openjdk:13-jdk-alpine
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
VOLUME /tmp

#this is for (jar file) building within docker
ARG DEPENDENCY=/workspace/app/target/dependency
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF

#this is for (jar file) building with Spring outside docker
#ARG DEPENDENCY=target/dependency
#COPY ${DEPENDENCY}/BOOT-INF/lib /app/lib
#COPY ${DEPENDENCY}/BOOT-INF/classes /app
#COPY ${DEPENDENCY}/META-INF /app/META-INF
ENTRYPOINT ["java","-cp","app:app/lib/*", "com.example.restservice.RestServiceApplication"]

#ARG JAR_FILE=target/*.jar
#COPY ${JAR_FILE} app.jar

#ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar /app.jar ${0} ${@}"]
# for: docker run -p 9090:9090 -e "JAVA_OPTS=-Ddebug -Xmx128m" myorg/myapp --server.port=9000
# or:  docker run -p 9000:9000 myorg/myapp --server.port=9000

#ENTRYPOINT ["java","-jar","app.jar"]

#COPY run.sh .      #content of run.sh: #/bin/sh <new line> exec java ${JAVA_OPTS}-jar /app.jar ${@}
#ENTRYPOINT ["run.sh"]