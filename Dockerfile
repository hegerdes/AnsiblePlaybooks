FROM python:3.9-slim-bullseye

WORKDIR /app
COPY requirements.txt /app/requirements.txt
RUN apt-get update && apt-get install -y curl gpg \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key \
    | gpg --dearmor -o /usr/share/keyrings/nodejs-archive-keyring.gpg \
    && export NODE_ARCH="arch=amd64 signed-by=/usr/share/keyrings/nodejs-archive-keyring.gpg" \
    && echo "deb [$NODE_ARCH] https://deb.nodesource.com/node_16.x bullseye main" \
    > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update && apt-get install -y --no-install-recommends \
    ssh-client jq rsync nodejs && rm -rf /var/lib/apt/lists/* \
    && pip3 install --no-cache-dir -r requirements.txt

ARG COMMIT_HASH="none"
ARG COMMIT_TAG="none"
ENV COMMIT_HASH=$COMMIT_HASH
ENV COMMIT_TAG=$COMMIT_TAG
LABEL commit-hash=$COMMIT_HASH
LABEL commit-tag=$COMMIT_TAG
