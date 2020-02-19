::docker build -f ./363_11_222.Dockerfile  -t kostua16/spring-boot-maven-build:maven-3.6.3-jdk-11-spring-2.2.2 -t kostua16/spring-boot-maven-build:latest ./
docker build -f ./Dockerfile --build-arg JDK_VERSION=8 --build-arg MAVEN_VERSION=3.6.3 --build-arg SPRING_VERSION=2.2.2.RELEASE -t kostua16/spring-boot-maven-build:maven-3.6.3-jdk-8-spring-2.2.2 ./
docker push kostua16/spring-boot-maven-build:maven-3.6.3-jdk-8-spring-2.2.2
pause