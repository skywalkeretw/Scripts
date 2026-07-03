# Use Ubuntu as the base image
FROM ubuntu:latest

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    bash \
    ca-certificates \
    git \
    nodejs \
    npm \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install Bob Shell
RUN curl -fsSL https://bob.ibm.com/download/bobshell.sh | bash

# Configure Bob Shell settings
RUN mkdir -p /root/.bob && \
    jq -n '{"security":{"auth":{"selectedType":"api-key"}},"autoAcceptLicense":true,"autoAcceptIbmLicense":true,"telemetry":{"enabled":false},"autoTrustWorkspace":true,"approvalMode":"auto_approve","ibm":{"isNotFirstTime":true,"licenseConsent":true},"ibm_secrets":{},"prev_version":"1.0.6"}' > /root/.bob/settings.json && \
    jq -n '{"/workspace":"TRUST_FOLDER"}' > /root/.bob/trustedFolders.json

# Create project directory for volume mount
RUN mkdir -p /workspace

# Set the working directory
WORKDIR /workspace

# Declare BOBSHELL_API_KEY environment variable (will be set at runtime)
ENV BOBSHELL_API_KEY=""

# Default command to run Bob Shell
CMD ["bob"]
