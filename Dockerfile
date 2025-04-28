# Use official Tomcat image with Java 17
FROM tomcat:9.0-jdk17

# (Optional) Clean default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file into Tomcat
COPY dist/plant_shop.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080 (important for Railway or any cloud)
EXPOSE 8080

# Start Tomcat when container starts
CMD ["catalina.sh", "run"]
