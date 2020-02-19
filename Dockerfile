ARG JDK_VERSION=8
FROM openjdk:${JDK_VERSION}-jdk-alpine
ARG JDK_VERSION
ENV JDK_VERSION=${JDK_VERSION}
ENV LANG=C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/java-1.${JDK_VERSION}-openjdk
ENV MAVEN_HOME=/usr/share/maven
ENV PATH=${MAVEN_HOME}/bin:${JAVA_HOME}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV MAVEN_CONFIG=/root/.m2

ARG MAVEN_VERSION=3.6.3
ENV MAVEN_VERSION=${MAVEN_VERSION}
ENV MAVEN_URL=https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz
ENV MAVEN_SHA512_URL=https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512

RUN /bin/sh -c set -eux; \
    wget -O /apache-maven.tar.gz "${MAVEN_URL}"; \
    wget -O /apache-maven.sha512 "${MAVEN_SHA512_URL}"; \
    echo "$(cat /apache-maven.sha512) */apache-maven.tar.gz" | sha512sum -c -; \
    mkdir -p "${MAVEN_HOME}"; \
    tar --extract --file /apache-maven.tar.gz --directory "${MAVEN_HOME}" --strip-components 1; \
    rm /apache-maven.tar.gz; \
    rm /apache-maven.sha512; \
    java -Xshare:dump;
COPY ./settings.xml /usr/share/maven/conf/settings.xml

WORKDIR /root/app

ARG SPRING_VERSION=2.2.2.RELEASE
ENV SPRING_VERSION=${SPRING_VERSION}
ENV NEXUS_URL='http://host.docker.internal:8081/repository/maven-central/'
COPY ./pom.xml ./dependencies_pom.xml
RUN mvn -f ./dependencies_pom.xml  -B -e -C -T 2C -Dspring.version=${SPRING_VERSION} org.apache.maven.plugins:maven-dependency-plugin:3.1.1:go-offline; \
    rm ./dependencies_pom.xml;
ENV POM_FILE=pom.xml
ENV BUILD_CMD=verify
ENV SPRING_APPLICATION_JSON="{}"
CMD mvn -f ${POM_FILE} -B -e -C -T 2C -Dspring.version=${SPRING_VERSION} ${BUILD_CMD} -Dspring.application.json="${SPRING_APPLICATION_JSON}"
VOLUME [ "/root/app/", "/root/.m2" ]