# Use official Tomcat image (Java 17)
FROM tomcat:10.1-jdk17

# Maintainer info
LABEL maintainer="yourname@example.com"

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your entire WebContent folder into Tomcat ROOT
COPY ./WebContent /usr/local/tomcat/webapps/ROOT

# ✅ WEB-INF is already inside WebContent, so no need for a second COPY
# Just keep one COPY statement (above)

# Expose Tomcat default port
EXPOSE 8080

# Start Tomcat when container runs
CMD ["catalina.sh", "run"]
