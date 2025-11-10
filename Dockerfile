# Use official Tomcat image with Java 17
FROM tomcat:10.1-jdk17

# Remove default webapps from Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your web folder (contains JSPs, HTML, WEB-INF, etc.)
COPY ./web /usr/local/tomcat/webapps/ROOT

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
