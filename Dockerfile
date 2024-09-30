# Install the following software:
# Dotnet SDK 8.0
# Curl, Unzip, Git
# Sonarqube CLI
# Snyk CLI
# Yamllint

# Use an official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

# Set the working directory inside the container
WORKDIR /build

# Install required tools: curl, git, unzip, yamllint
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    yamllint

# Install SonarQube CLI
RUN curl -sSLo sonarscanner-cli.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip && \
    unzip sonarscanner-cli.zip -d /opt && \
    ln -s /opt/sonar-scanner-4.8.0.2856-linux/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    rm sonarscanner-cli.zip

# Install Snyk CLI using npm
RUN npm install -g snyk

# Add SonarQube scanner and Snyk to PATH
ENV PATH="$PATH:/opt/sonar-scanner-4.8.0.2856-linux/bin:/root/.local/bin"

# The container will be used as an environment for building .NET projects
CMD ["dotnet", "--version"]
