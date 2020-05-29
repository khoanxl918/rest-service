FROM openjdk:13-jdk-alpine
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
VOLUME /tmp
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar /app.jar ${0} ${@}"]
# for: docker run -p 9090:9090 -e "JAVA_OPTS=-Ddebug -Xmx128m" myorg/myapp --server.port=9000
# or:  docker run -p 9000:9000 myorg/myapp --server.port=9000

#ENTRYPOINT ["java","-jar","app.jar"]

#COPY run.sh .      #content of run.sh: #/bin/sh <new line> exec java ${JAVA_OPTS}-jar /app.jar ${@}
#ENTRYPOINT ["run.sh"]