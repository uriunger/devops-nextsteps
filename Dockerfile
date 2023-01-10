FROM maven:3-openjdk-18 as builder

RUN mkdir /app
COPY . /app
RUN cd /app && \
    mvn clean install

FROM tomcat:11.0

COPY --from=builder /app/target/*war /usr/local/tomcat/webapps/

WORKDIR /tmp

CMD ["catalina.sh", "run"]