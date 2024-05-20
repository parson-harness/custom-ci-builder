# Use the official Ubuntu base image
FROM ubuntu:20.04

# Set environment variables to non-interactive for the installation process
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install basic packages
RUN apt-get update && \
    apt-get install -y \
    curl \
    wget \
    unzip \
    gnupg \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    lsb-release

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip && \
    unzip terraform_1.5.0_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_1.5.0_linux_amd64.zip

# Install Maven
RUN apt-get install -y maven

# Install .NET SDK
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-6.0

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Verify installations
RUN az --version && \
    aws --version && \
    terraform --version && \
    mvn -v && \
    dotnet --version

# Set the default command to bash
CMD ["bash"]
