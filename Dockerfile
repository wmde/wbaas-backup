FROM ubuntu:bionic

ARG AWS_CLI_VERSION=2.13.9
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN useradd -u 1234 -m notroot && \
    mkdir -p /backups/tmp && \
    mkdir -p /backups/output && \
    chown notroot /backups -R && \
    apt-get update && apt-get install --yes --no-install-recommends \
    ca-certificates=20230311ubuntu0.18.04.1 \
    curl=7.58.0-2ubuntu3.24 \
    gnupg=2.2.4-1ubuntu1.6 \
    mydumper=0.9.1-5 \
    mariadb-client=1:10.1.48-0ubuntu0.18.04.1 \
    unzip=6.0-21ubuntu1.2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    curl "https://awscli.amazonaws.com/awscli-exe-$TARGETOS-${TARGETARCH/amd64/x86_64}-$AWS_CLI_VERSION.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf ./aws awscliv2.zip

USER notroot

WORKDIR /app

COPY --chown=notroot src/ /app

ENV DB_PORT="3306" \
    DB_HOST="localhost" \
    DO_UPLOAD="1" \
    MYDUMPER_VERBOSE_LEVEL="1" \
    STORAGE_ENDPOINT="storage.googleapis.com" \
    STORAGE_SIGNATURE_VERSION="S3v2" \
    REPLICATION_THRESHOLD="60" \
    SECONDARY_HOST="sql-mariadb-secondary.default.svc.cluster.local" \
    DO_CHECK_SECONDARY="1"

ENTRYPOINT [ "/app/entrypoint.sh" ]
