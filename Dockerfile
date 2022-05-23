FROM tomcat
COPY dist/hello.war /usr/local/tomcat/webapps
CMD ["catalina.sh", "run"]
