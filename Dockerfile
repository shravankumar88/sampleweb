FROM tomcat
WORKDIR .
COPY target/*.jar .
RUN rm -rf ROOT && mv *.jar ROOT.jar
ENTRYPOINT ["sh", "/usr/local/tomcat/bin/startup.sh"]