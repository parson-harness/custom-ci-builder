# Install the following software:
# OpenJDK 17
# Maven 3.9
# Curl, Unzip, Git
# Azure CLI
# Sonarqube CLI
# JaCoCo

# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the Maven version
ARG MAVEN_VERSION=3.9.4

# Install required packages
RUN apt-get update && \
    apt-get install -y curl unzip git && \
    rm -rf /var/lib/apt/lists/*

# Install Maven
RUN curl -fsSL https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    | tar -xz -C /opt && \
    ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven

# Set environment variables for Maven
ENV MAVEN_HOME /opt/maven
ENV PATH ${MAVEN_HOME}/bin:${PATH}

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install SonarQube CLI
RUN curl -sL https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip \
    -o sonar-scanner-cli.zip && \
    unzip sonar-scanner-cli.zip && \
    mv sonar-scanner-4.6.2.2472-linux /opt/sonar-scanner && \
    rm sonar-scanner-cli.zip

# Set environment variables for SonarQube CLI
ENV SONAR_SCANNER_HOME /opt/sonar-scanner
ENV PATH ${SONAR_SCANNER_HOME}/bin:${PATH}

# Install JaCoCo (latest version)
RUN curl -sL https://repo1.maven.org/maven2/org/jacoco/jacoco/0.8.7/jacoco-0.8.7.zip \
    -o jacoco.zip && \
    unzip jacoco.zip -d /opt/jacoco && \
    rm jacoco.zip

# Set environment variables for JaCoCo
ENV JACOCO_HOME /opt/jacoco
ENV PATH ${JACOCO_HOME}/bin:${PATH}

# Install JUnit (JUnit is typically managed by Maven, so no additional installation is needed)
# This is a placeholder to highlight that JUnit will be included as a dependency in Maven projects

# Verify installations
RUN java -version && \
    mvn -version && \
    az --version && \
    sonar-scanner --version

# Set work directory
WORKDIR /workspace

# Expose necessary ports (e.g., for debugging or application running)
EXPOSE 8080

# Define the entry point for the container
CMD ["bash"]
