# Use official Tomcat image with Java 17
FROM tomcat:10.1-jdk17

# Set working directory
WORKDIR /usr/local/tomcat

# Remove default Tomcat apps
RUN rm -rf webapps/*

# Copy your web content (HTML, JSP, WEB-INF)
COPY ./web ./webapps/ROOT

# Copy Java source files
COPY ./src /usr/src/app

# Compile Java source files into WEB-INF/classes
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes && \
    find /usr/src/app -name "*.java" > sources.txt && \
    javac -cp /usr/local/tomcat/lib/*:. -d /usr/local/tomcat/webapps/ROOT/WEB-INF/classes @sources.txt

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
