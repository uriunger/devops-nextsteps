FROM maven:3-openjdk-18 as builder

RUN mkdir /app
COPY . /app
RUN cd /app && \
    mvn clean install

FROM tomcat:9

COPY --from=builder /app/target/*war /usr/local/tomcat/webapps/ROOT.war

CMD ["catalina.sh", "run"]