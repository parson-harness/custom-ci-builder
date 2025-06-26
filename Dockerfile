# Customized container for IAC runners

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install core dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    unzip \
    jq \
    gnupg \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    python3 \
    python3-pip \
    make \
    sudo \
    sed \
    gawk \
    bash \
    coreutils \
    && rm -rf /var/lib/apt/lists/*

# Install Terraform
ENV TERRAFORM_VERSION=1.9.0
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install OpenTofu
ENV TOFU_VERSION=1.6.2
RUN wget https://github.com/opentofu/opentofu/releases/download/v${TOFU_VERSION}/tofu_${TOFU_VERSION}_linux_amd64.zip && \
    unzip tofu_${TOFU_VERSION}_linux_amd64.zip && \
    mv tofu /usr/local/bin/ && \
    rm tofu_${TOFU_VERSION}_linux_amd64.zip

# Install TFLint
ENV TFLINT_VERSION=0.51.1
RUN curl -L "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip" -o tflint.zip && \
    unzip tflint.zip && \
    mv tflint /usr/local/bin/ && \
    rm tflint.zip

# Install kubectl
ENV KUBECTL_VERSION=1.30.1
RUN curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && mv kubectl /usr/local/bin/

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install tfsec
RUN wget https://github.com/aquasecurity/tfsec/releases/latest/download/tfsec-linux-amd64 -O /usr/local/bin/tfsec && \
    chmod +x /usr/local/bin/tfsec

# Install Checkov
RUN pip3 install checkov

# Install Wiz CLI
RUN curl -L https://downloads.wiz.io/wizcli/latest/wizcli-linux-amd64 -o /usr/local/bin/wiz && \
    chmod +x /usr/local/bin/wiz

# Install Terragrunt
ENV TERRAGRUNT_VERSION=0.56.4
RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    chmod +x terragrunt_linux_amd64 && \
    mv terragrunt_linux_amd64 /usr/local/bin/terragrunt

# Optional: Print versions for verification
RUN terraform -version && \
    tofu version && \
    tflint --version && \
    tfsec --version && \
    checkov --version && \
    terragrunt -version && \
    kubectl version --client && \
    az version && \
    wiz version

WORKDIR /workspace

ENTRYPOINT ["/bin/bash"]
