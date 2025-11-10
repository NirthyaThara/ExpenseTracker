# Use official Tomcat image (Java 17)
FROM tomcat:10.1-jdk17

# Maintainer info
LABEL maintainer="yourname@example.com"

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your web files into Tomcat's ROOT folder
# Adjust "WebContent" if your folder is named differently
COPY ./WebContent /usr/local/tomcat/webapps/ROOT

# Copy compiled classes and libraries (if present)
# This ensures servlets and WEB-INF configurations are deployed
COPY ./WEB-INF /usr/local/tomcat/webapps/ROOT/WEB-INF

# Expose default Tomcat port
EXPOSE 8080

# Start Tomcat when container runs
CMD ["catalina.sh", "run"]
