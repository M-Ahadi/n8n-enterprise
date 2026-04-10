FROM node:24.14.1-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    COREPACK_ENABLE_DOWNLOAD_PROMPT=0 \
    PNPM_HOME=/usr/local/share/pnpm

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    git \
    build-essential \
    python3 \
    python3-pip \
  && rm -rf /var/lib/apt/lists/*

# Enable Corepack and install pnpm
ENV COREPACK_VERSION=10.22.0
RUN corepack enable \
 && corepack prepare pnpm@${COREPACK_VERSION} --activate

# Install Docker CLI + Compose plugin
RUN mkdir -p /etc/apt/keyrings \
 && curl -fsSL https://download.docker.com/linux/debian/gpg \
    | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/debian bookworm stable" \
    > /etc/apt/sources.list.d/docker.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    docker-ce-cli \
    docker-buildx-plugin \
    docker-compose-plugin \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspaces

# Copy optional patch script (if present in build context) and ensure permissions
# If you don't have patch.sh in the build context, this file copy can be removed.
COPY patch.sh /workspaces/patch.sh
RUN chmod +x /workspaces/patch.sh

# Default command: keep an interactive shell (devcontainer will run postCreateCommand)
CMD ["/bin/bash", "-c", "/workspaces/patch.sh"]
