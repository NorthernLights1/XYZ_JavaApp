# Use a Tomcat 9 base image with Java 17 support
FROM tomcat:9-jdk17

# Remove the default web applications (optional)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file from the Maven target directory into Tomcat's webapps
COPY /home/ec2-user/jenkins/workspace/XYZ_JavaApp/target/XYZ_JavaApp.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080 for Tomcat
EXPOSE 8080
